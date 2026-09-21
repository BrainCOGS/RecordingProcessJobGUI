# /// script
# requires-python = ">=3.12"
# dependencies = ["pytest"]
# ///
"""Regression tests for the cross-platform dat_path fixup in open_phy.py.

kilosort bakes an absolute raw-data path into params.py using the mount of the
machine that sorted the data -- /mnt/cup/... on this pipeline's linux cluster.
On macOS that share is /Volumes/..., on Windows a UNC path, so the recorded
string does not resolve and phy drops TraceView with only

    [W] gui:737  Could not create view TraceView.

in phy.log. Observed on a real kilosort4 session; these cover the rewrite that
fixes it.

Run with:

    uv run --script tests/test_open_phy_dat_path.py
"""

from __future__ import annotations

import ast
import re
import sys
import tempfile
from pathlib import Path

import pytest

# open_phy.py imports phy at module scope, which is a heavy dependency these
# tests do not need, so load just the helpers above main().
_SRC = (Path(__file__).resolve().parent.parent
        / "PythonScripts" / "open_phy.py").read_text()
_BODY = _SRC.split("from phy.apps.template import template_gui", 1)[1].split("def main(")[0]
_NS: dict = {}
exec(  # noqa: S102 - loading our own source, not user input
    "import ast, re, sys, tempfile\nfrom pathlib import Path\n" + _BODY, _NS
)

_dat_paths = _NS["_dat_paths"]
_relocate = _NS["_relocate"]
_localize_params = _NS["_localize_params"]


def write_params(tmp_path: Path, dat_path, extra: str = "") -> Path:
    """Write a minimal params.py the way kilosort does."""
    params = tmp_path / "params.py"
    params.write_text(
        "n_channels_dat = 385\n"
        "offset = 0\n"
        "sample_rate = 30000\n"
        "dtype = 'int16'\n"
        "hp_filtered = True\n"
        f"dat_path = {dat_path!r}\n" + extra
    )
    return params


# --- parsing --------------------------------------------------------------

def test_reads_a_plain_string(tmp_path):
    p = write_params(tmp_path, "/mnt/cup/x/temp_wh.dat")
    assert _dat_paths(p.read_text()) == ["/mnt/cup/x/temp_wh.dat"]


def test_reads_a_list(tmp_path):
    p = write_params(tmp_path, ["/mnt/cup/a.dat", "/mnt/cup/b.dat"])
    assert _dat_paths(p.read_text()) == ["/mnt/cup/a.dat", "/mnt/cup/b.dat"]


def test_missing_dat_path_is_none():
    assert _dat_paths("sample_rate = 30000\n") is None


def test_unparseable_dat_path_is_none():
    # A computed value rather than a literal; must not raise.
    assert _dat_paths("dat_path = os.path.join(a, b)\n") is None


def test_empty_string_dat_path():
    assert _dat_paths("dat_path = ''\n") == [""]


# --- relocation -----------------------------------------------------------

def test_finds_raw_file_beside_params(tmp_path):
    (tmp_path / "temp_wh.dat").write_bytes(b"")
    got = _relocate("/mnt/cup/braininit/somewhere/temp_wh.dat", tmp_path)
    assert got == "temp_wh.dat"


def test_returns_none_when_raw_file_is_absent(tmp_path):
    assert _relocate("/mnt/cup/braininit/x/temp_wh.dat", tmp_path) is None


def test_windows_unc_forward_slash(tmp_path):
    (tmp_path / "temp_wh.dat").write_bytes(b"")
    got = _relocate("//cup.pni.princeton.edu/braininit/x/temp_wh.dat", tmp_path)
    assert got == "temp_wh.dat"


def test_windows_unc_backslash(tmp_path):
    (tmp_path / "temp_wh.dat").write_bytes(b"")
    got = _relocate(r"\\cup.pni.princeton.edu\braininit\x\temp_wh.dat", tmp_path)
    assert got == "temp_wh.dat"


def test_windows_mapped_drive_is_treated_as_absolute(tmp_path):
    # A drive-letter path is not absolute to posixpath, so without the explicit
    # check the rewrite would be skipped and TraceView lost on windows-sorted
    # data. The raw file is still found beside params.py.
    (tmp_path / "temp_wh.dat").write_bytes(b"")
    assert _NS["_is_absolute"](r"X:\braininit\x\temp_wh.dat")
    assert _relocate(r"X:\braininit\x\temp_wh.dat", tmp_path) == "temp_wh.dat"


def test_absoluteness_is_platform_independent():
    is_abs = _NS["_is_absolute"]
    assert is_abs("/mnt/cup/x.dat")
    assert is_abs(r"\\cup.pni.princeton.edu\share\x.dat")
    assert is_abs("//cup.pni.princeton.edu/share/x.dat")
    assert is_abs("C:/data/x.dat")
    assert not is_abs("temp_wh.dat")
    assert not is_abs("sub/temp_wh.dat")


def test_windows_sorted_session_rewrites_end_to_end(tmp_path):
    (tmp_path / "temp_wh.dat").write_bytes(b"")
    params = write_params(tmp_path, r"X:\braininit\x\temp_wh.dat")

    out = _localize_params(tmp_path, params)

    assert out != params
    ns: dict = {}
    exec(out.read_text(), ns)  # noqa: S102
    assert ns["dat_path"] == "temp_wh.dat"
    assert Path(ns["dir_path"]) == tmp_path


def test_macos_volumes_prefix(tmp_path):
    (tmp_path / "temp_wh.dat").write_bytes(b"")
    got = _relocate("/Volumes/braininit/x/temp_wh.dat", tmp_path)
    assert got == "temp_wh.dat"


# --- end to end -----------------------------------------------------------

def test_rewrites_unreachable_path_and_pins_dir_path(tmp_path):
    (tmp_path / "temp_wh.dat").write_bytes(b"")
    params = write_params(tmp_path, "/mnt/cup/braininit/x/temp_wh.dat")

    out = _localize_params(tmp_path, params)

    assert out != params, "should hand back a patched copy"
    text = out.read_text()
    ns: dict = {}
    exec(text, ns)  # noqa: S102
    assert ns["dat_path"] == "temp_wh.dat"
    # Without dir_path, phy would look for the .npy files next to the temp file.
    assert Path(ns["dir_path"]) == tmp_path
    assert ns["sample_rate"] == 30000, "other keys must survive"


def test_original_params_is_not_modified(tmp_path):
    (tmp_path / "temp_wh.dat").write_bytes(b"")
    params = write_params(tmp_path, "/mnt/cup/braininit/x/temp_wh.dat")
    before = params.read_text()

    _localize_params(tmp_path, params)

    assert params.read_text() == before, "the file on the share must be untouched"


def test_reachable_absolute_path_is_left_alone(tmp_path):
    raw = tmp_path / "temp_wh.dat"
    raw.write_bytes(b"")
    params = write_params(tmp_path, str(raw))
    assert _localize_params(tmp_path, params) == params


def test_relative_path_is_left_alone(tmp_path):
    (tmp_path / "temp_wh.dat").write_bytes(b"")
    params = write_params(tmp_path, "temp_wh.dat")
    assert _localize_params(tmp_path, params) == params


def test_unlocatable_raw_file_falls_back_to_original(tmp_path):
    # No temp_wh.dat anywhere: phy should still open, just without TraceView.
    params = write_params(tmp_path, "/mnt/cup/braininit/x/temp_wh.dat")
    assert _localize_params(tmp_path, params) == params


def test_missing_dat_path_falls_back_to_original(tmp_path):
    params = tmp_path / "params.py"
    params.write_text("sample_rate = 30000\ndtype = 'int16'\n")
    assert _localize_params(tmp_path, params) == params


def test_multi_file_dat_path_all_rewritten(tmp_path):
    for n in ("a.dat", "b.dat"):
        (tmp_path / n).write_bytes(b"")
    params = write_params(tmp_path, ["/mnt/cup/x/a.dat", "/mnt/cup/x/b.dat"])

    out = _localize_params(tmp_path, params)

    ns: dict = {}
    exec(out.read_text(), ns)  # noqa: S102
    assert ns["dat_path"] == ["a.dat", "b.dat"]


def test_partially_unlocatable_multi_file_falls_back(tmp_path):
    # Only one of the two exists; rewriting half would be worse than not at all.
    (tmp_path / "a.dat").write_bytes(b"")
    params = write_params(tmp_path, ["/mnt/cup/x/a.dat", "/mnt/cup/x/b.dat"])
    assert _localize_params(tmp_path, params) == params


def test_path_with_spaces(tmp_path):
    d = tmp_path / "my data"
    d.mkdir()
    (d / "temp_wh.dat").write_bytes(b"")
    params = write_params(d, "/mnt/cup/braininit/x/temp_wh.dat")

    out = _localize_params(d, params)

    ns: dict = {}
    exec(out.read_text(), ns)  # noqa: S102
    assert ns["dat_path"] == "temp_wh.dat"
    assert Path(ns["dir_path"]) == d


if __name__ == "__main__":
    raise SystemExit(pytest.main([__file__, "-v", "--no-header", "-q"]))
