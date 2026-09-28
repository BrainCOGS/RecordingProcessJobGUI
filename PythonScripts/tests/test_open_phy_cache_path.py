"""Regression tests for phy's cache overflowing Windows' MAX_PATH.

phy caches through joblib in <kilosort dir>\\.phy. On the share, a kilosort
directory is already ~170 characters of UNC path, and joblib nests
<module>\\<class>\\<method>\\func_code.py.<uuid>-<pid>-<thread> beneath it, so
its writes land at 276-302 characters. With LongPathsEnabled=0 every one fails
with FileNotFoundError and the correlogram and amplitude views stay empty:

    FileNotFoundError: [Errno 2] No such file or directory:
    '\\\\cup.pni.princeton.edu\\braininit\\...\\job_id_1396\\kilosort4_output
    \\.phy\\phy\\apps\\base\\TemplateMixin\\get_spike_template_amplitudes
    \\func_code.py.364574bf3c9d42aaad82c80efd663613-78608-1274875719232'

The fix keeps the cache where it was but hands phy the \\\\?\\ extended-length
form of its path, which Windows exempts from MAX_PATH.

Run with:

    QT_QPA_PLATFORM=offscreen uv run --with phy --with pytest \
        pytest PythonScripts/tests
"""

from __future__ import annotations

import os
import sys
import types
from pathlib import Path

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import open_phy  # noqa: E402
from phy.apps.base import BaseController  # noqa: E402

ROOT = r"\\cup.pni.princeton.edu\braininit\Data\Processed\electrophysiology\jk8386\jk8386_jk131"
#: The session from the traceback above (no behavior session, so the
#: recording folder is <yyyymmdd_HHMMSS>).
KS_DIR = ROOT + (r"\20260826_153642\jk131_08262026_g0\jk131_08262026_g0_imec0"
                 r"\job_id_1396\kilosort4_output")
#: A normally named session from the same subject, 4 characters shorter.
KS_DIR_G0 = ROOT + (r"\20260826_g0\jk131_20260826_g0\jk131_20260826_g0_imec0"
                    r"\job_id_1317\kilosort4_output")
#: The paths joblib failed to write, relative to <kilosort dir>\.phy.
OBSERVED_TAILS = (
    r"\phy\apps\base\BaseController\_get_correlograms"
    r"\func_code.py.2430c8809fb746a8a89a8f9bc59acfba-78608-1274875719232",
    r"\phy\apps\base\TemplateMixin\get_spike_template_amplitudes"
    r"\func_code.py.364574bf3c9d42aaad82c80efd663613-78608-1274875719232",
)


# --- the bug ---------------------------------------------------------------

def test_observed_cache_writes_exceed_max_path():
    """Documents the failure: the share-side cache paths are over the limit."""
    for tail in OBSERVED_TAILS:
        assert len(KS_DIR + r"\.phy" + tail) >= open_phy.MAX_PATH


def test_cache_depth_covers_observed_tails():
    for tail in OBSERVED_TAILS:
        assert len(tail) <= open_phy.CACHE_DEPTH


def test_failing_session_is_too_deep():
    assert open_phy._cache_too_deep(KS_DIR, windows=True, long_paths=False)


def test_normally_named_session_is_too_deep_as_well():
    """The odd folder name is not the cause; <date>_g0 sessions overflow too."""
    assert open_phy._cache_too_deep(KS_DIR_G0, windows=True, long_paths=False)


# --- when the default is kept ----------------------------------------------

def test_short_local_directory_keeps_default():
    short = r"D:\NPX_DATA\jk131\job_id_1396\kilosort4_output"
    assert not open_phy._cache_too_deep(short, windows=True, long_paths=False)


def test_long_paths_enabled_keeps_default():
    assert not open_phy._cache_too_deep(KS_DIR, windows=True, long_paths=True)


def test_non_windows_keeps_default():
    assert not open_phy._cache_too_deep(KS_DIR, windows=False, long_paths=False)


def test_empty_directory_string_keeps_default():
    assert not open_phy._cache_too_deep("", windows=True, long_paths=False)


def test_threshold_boundary():
    # Longest directory whose deepest cache path still fits (<= MAX_PATH - 1).
    fits = open_phy.MAX_PATH - 1 - len(r"\.phy") - open_phy.CACHE_DEPTH
    assert not open_phy._cache_too_deep("x" * fits, windows=True, long_paths=False)
    assert open_phy._cache_too_deep("x" * (fits + 1), windows=True, long_paths=False)


# --- LongPathsEnabled ------------------------------------------------------

def _fake_winreg(value=None, error=None):
    def query(key, name):
        if error:
            raise error
        return value, 4

    class _Key:
        def __enter__(self):
            return self

        def __exit__(self, *exc):
            return False

    return types.SimpleNamespace(
        HKEY_LOCAL_MACHINE=object(),
        OpenKey=lambda root, path: _Key(),
        QueryValueEx=query,
    )


def test_long_paths_off_outside_windows(monkeypatch):
    monkeypatch.setattr(open_phy.sys, "platform", "linux")
    assert open_phy._long_paths_enabled() is False


@pytest.mark.parametrize("value, expected", [(1, True), (0, False)])
def test_long_paths_reads_registry(monkeypatch, value, expected):
    monkeypatch.setattr(open_phy.sys, "platform", "win32")
    monkeypatch.setitem(sys.modules, "winreg", _fake_winreg(value))
    assert open_phy._long_paths_enabled() is expected


def test_long_paths_missing_value_is_off(monkeypatch):
    monkeypatch.setattr(open_phy.sys, "platform", "win32")
    monkeypatch.setitem(sys.modules, "winreg", _fake_winreg(error=FileNotFoundError()))
    assert open_phy._long_paths_enabled() is False


# --- the phy hook ----------------------------------------------------------

@pytest.fixture
def restore_set_cache(monkeypatch):
    monkeypatch.setattr(BaseController, "_set_cache", BaseController._set_cache)


def _controller(dir_path):
    fake = types.SimpleNamespace(dir_path=Path(dir_path))
    fake._clear_cache = lambda: BaseController._clear_cache(fake)
    return fake


def test_redirect_points_phy_at_given_cache(restore_set_cache, tmp_path):
    target = tmp_path / "elsewhere"
    open_phy._install_cache_redirect(target)
    ctl = _controller(tmp_path / "data")
    BaseController._set_cache(ctl)
    assert ctl.cache_dir == target
    assert ctl.context.cache_dir == target
    assert target.is_dir()


def test_redirect_honours_clear_cache(restore_set_cache, tmp_path):
    target = tmp_path / "elsewhere"
    (target / "memcache").mkdir(parents=True)
    stale = target / "memcache" / "stale.pkl"
    stale.write_bytes(b"x")
    open_phy._install_cache_redirect(target)
    BaseController._set_cache(_controller(tmp_path), clear_cache=True)
    assert not stale.exists()


# --- extended-length paths -------------------------------------------------

def test_unc_path_gets_unc_prefix():
    assert (open_phy._extended_path(r"\\cup.pni.princeton.edu\braininit\Data")
            == r"\\?\UNC\cup.pni.princeton.edu\braininit\Data")


def test_drive_path_gets_prefix():
    assert open_phy._extended_path(r"C:\Users\x") == r"\\?\C:\Users\x"


def test_already_extended_path_is_unchanged():
    for p in (r"\\?\C:\Users\x", r"\\?\UNC\server\share\x"):
        assert open_phy._extended_path(p) == p


def test_forward_slashes_become_backslashes():
    """\\\\?\\ turns off normalisation, so '/' would be a literal character."""
    assert (open_phy._extended_path("//server/share/a/b")
            == r"\\?\UNC\server\share\a\b")
    assert open_phy._extended_path("C:/a/b") == r"\\?\C:\a\b"


def test_dot_segments_are_collapsed():
    assert open_phy._extended_path(r"C:\a\.\b\..\c") == r"\\?\C:\a\c"


def test_trailing_separator_is_dropped():
    assert open_phy._extended_path("C:\\a\\") == r"\\?\C:\a"


@pytest.mark.parametrize("path", ["", "relative\\dir", r"\rooted\no\drive"])
def test_non_absolute_paths_are_rejected(path):
    with pytest.raises(ValueError):
        open_phy._extended_path(path)


def test_share_cache_keeps_every_observed_write_on_the_share():
    """The cache stays under the kilosort directory, just via \\\\?\\UNC."""
    cache = open_phy._extended_path(KS_DIR + r"\.phy")
    assert cache.startswith("\\\\?\\UNC\\cup.pni.princeton.edu\\braininit\\")
    assert cache.endswith(r"\kilosort4_output\.phy")
    assert "/" not in cache


