# /// script
# requires-python = ">=3.12"
# dependencies = ["phy"]
# ///
"""Launch the phy template GUI on a kilosort output directory.

Cross-platform replacement for open_phy.BAT, which was cmd.exe-only (MATLAB's
system() on macOS handed it to zsh, which refused it outright) and additionally
assumed phy lived in a conda env named on the command line.

The dependency block above is inline PEP 723 metadata, so

    uv run --script PythonScripts/open_phy.py <sorting_output_dir>

resolves phy into its own cached environment on first use and reuses it after
that. No conda. uv always runs a PEP 723 script in isolation, so this never
picks up the repo's pyproject.toml -- which is just as well, since that project
requires a different interpreter than the Qt tools do.

Python floor
------------
`>=3.12` rather than a pin: phy, and the numpy/scipy/PyQt5 stack beneath it,
publish wheels for 3.14, so this tracks whatever modern interpreter uv offers
instead of tying the GUI to a version going EOL. Verified importing
phy.apps.template on 3.14.7 (numpy 2.5.3, scipy 1.18.1, PyQt5 5.15.11).

Cross-platform dat_path
-----------------------
kilosort records the raw-data path in params.py as an absolute path, using the
mount of the machine that did the sorting -- on this pipeline's linux cluster
that is /mnt/cup/... The same share is /Volumes/... on macOS and a UNC path on
Windows, so the recorded string does not resolve, phy cannot open the raw
recording, and it drops TraceView with only a terse warning in phy.log.

This launcher detects that and hands phy a patched copy of params.py from a
temp directory, leaving the file on the share untouched. See _localize_params.

The directory argument is optional and defaults to the current working
directory, matching the old .BAT, which relied on the caller's cd.
"""

from __future__ import annotations

import ast
import re
import sys
import tempfile
from pathlib import Path

from phy.apps.template import template_gui

#: Mount prefixes for the same lab share, one per platform. The sorting
#: pipeline runs on linux and bakes its own prefix into params.py.
SHARE_PREFIXES = (
    "/mnt/cup/",                     # linux (the sorting cluster)
    "/Volumes/",                     # macOS
    "//cup.pni.princeton.edu/",      # windows, UNC forward-slash form
    "\\\\cup.pni.princeton.edu\\\\",      # windows, UNC backslash form
)


def _dat_paths(params_text: str) -> list[str] | None:
    """Return the dat_path value from params.py text, always as a list."""
    m = re.search(r"^dat_path\s*=\s*(.+?)\s*$", params_text, re.M)
    if not m:
        return None
    try:
        value = ast.literal_eval(m.group(1))
    except (ValueError, SyntaxError):
        return None
    if isinstance(value, str):
        return [value]
    if isinstance(value, (list, tuple)) and all(isinstance(v, str) for v in value):
        return list(value)
    return None


def _is_absolute(dat_path: str) -> bool:
    """True if dat_path is absolute on *any* platform, not just this one.

    Path() only understands the host flavour, so on POSIX a Windows path like
    C:\\data\\x.dat or \\\\server\\share\\x.dat reads as relative -- which would
    make a linux-sorted session look fine while a windows-sorted one silently
    skipped the rewrite. Checked explicitly so the fixup behaves the same
    wherever it runs.
    """
    if Path(dat_path).is_absolute():
        return True
    if re.match(r"^[A-Za-z]:[\\/]", dat_path):      # C:\... or C:/...
        return True
    if dat_path.startswith("\\\\") or dat_path.startswith("//"):  # UNC
        return True
    return False


def _relocate(dat_path: str, data_dir: Path) -> str | None:
    """Find `dat_path` on this machine, or None if it cannot be located.

    Two strategies, in order:

    1. The raw file normally sits beside params.py, so try that first. This is
       the common case and needs no knowledge of mount points.
    2. Otherwise, strip a known share prefix and look for the remainder beneath
       each ancestor of data_dir. That covers a raw file kept outside the
       sorting output directory, without hardcoding this machine's mount.
    """
    # Take the basename by hand: PurePosixPath would not split a windows path.
    normalized = dat_path.replace("\\", "/")
    basename = normalized.rsplit("/", 1)[-1]

    local = data_dir / basename
    if local.is_file():
        return basename

    for prefix in SHARE_PREFIXES:
        pfx = prefix.replace("\\", "/")
        if not normalized.startswith(pfx):
            continue
        tail = normalized[len(pfx):]
        # Try the tail whole, then with its leading share-name component
        # dropped, since the prefixes differ in whether they include it.
        tails = [tail]
        if "/" in tail:
            tails.append(tail.split("/", 1)[1])
        for parent in [data_dir, *data_dir.parents]:
            for t in tails:
                candidate = parent / t
                if candidate.is_file():
                    return str(candidate)
        break

    return None


def _localize_params(data_dir: Path, params: Path) -> Path:
    """Return a params.py whose dat_path resolves on this machine.

    kilosort writes dat_path as an absolute path using whatever mount the
    sorting machine had -- typically /mnt/cup/... on the linux cluster. That
    string does not resolve on macOS (/Volumes/...) or Windows (a UNC path),
    so phy cannot open the raw recording and drops TraceView with a bare
    "Could not create view TraceView" warning.

    params.py on the share is left untouched: it is shared data, is often
    read-only, and rewriting it would break the machine that sorted the data.
    Instead a patched copy is written to a temp directory. That copy also sets
    dir_path explicitly, because phy defaults dir_path to the params.py
    location -- without it, phy would look for the .npy files, and write its
    .phy cache, next to the temp file rather than in the real directory.

    Returns the params.py to hand to phy: the patched copy, or the original
    when no rewrite is needed or possible.
    """
    text = params.read_text()
    dat_paths = _dat_paths(text)

    if not dat_paths:
        return params

    # Relative paths already resolve against dir_path, and existing absolute
    # ones are fine as they are.
    if all(not _is_absolute(d) or Path(d).exists() for d in dat_paths):
        return params

    replacements = []
    for d in dat_paths:
        if not _is_absolute(d) or Path(d).exists():
            replacements.append(d)
            continue
        found = _relocate(d, data_dir)
        if found is None:
            print(
                f"Note: dat_path in params.py points at {d}, which does not "
                "exist on this machine, and the raw file could not be located. "
                "phy will open without TraceView.",
                file=sys.stderr,
            )
            return params
        replacements.append(found)

    new_value = replacements[0] if len(replacements) == 1 else replacements
    patched = re.sub(
        r"^dat_path\s*=\s*.+?$",
        "dat_path = " + repr(new_value),
        text,
        count=1,
        flags=re.M,
    )
    # phy defaults dir_path to the params.py directory; pin it to the real one.
    patched += f"\ndir_path = {str(data_dir)!r}\n"

    tmp = Path(tempfile.mkdtemp(prefix="phy_params_")) / "params.py"
    tmp.write_text(patched)
    print(f"Rewrote dat_path for this platform: {dat_paths[0]} -> "
          f"{replacements[0]}", file=sys.stderr)
    return tmp


def main(argv: list[str]) -> int:
    data_dir = Path(argv[0]).expanduser() if argv else Path.cwd()

    if not data_dir.is_dir():
        print(f"Not a directory: {data_dir}", file=sys.stderr)
        return 1

    # params.py is what the sorter writes. The old .BAT asked for win_params.py,
    # a filename this pipeline has never produced.
    params = data_dir / "params.py"
    if not params.is_file():
        print(
            f"No params.py in {data_dir}; is this a kilosort output directory?",
            file=sys.stderr,
        )
        return 1

    params = _localize_params(data_dir, params)

    template_gui(params)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
