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

Cache location on Windows
-------------------------
phy caches through joblib in <dir_path>\\.phy, and joblib nests
<module>\\<class>\\<method>\\func_code.py.<uuid>-<pid>-<thread> beneath it. A
kilosort directory on the share is already ~170 characters of UNC path, so
those writes land near 300 characters. Unless LongPathsEnabled is set, Windows
refuses anything at or over MAX_PATH (260) with FileNotFoundError, and the
correlogram and amplitude views come up empty.

When that would happen, phy is handed the \\\\?\\ extended-length form of its
usual cache directory (\\\\?\\UNC\\server\\share\\... for the share). Windows
exempts \\\\?\\ paths from MAX_PATH whatever LongPathsEnabled says, so the cache
stays next to the data, as it always has. joblib builds everything below it
with os.path.join, so the backslash-only rule \\\\?\\ imposes holds all the
way down. See _cache_too_deep and _extended_path.

The directory argument is optional and defaults to the current working
directory, matching the old .BAT, which relied on the caller's cd.
"""

from __future__ import annotations

import ast
import ntpath
import re
import sys
import tempfile
from pathlib import Path

from phy.apps.template import template_gui

#: Mount prefixes for the same lab share, one per platform. The sorting
#: pipeline runs on linux and bakes its own prefix into params.py.
SHARE_PREFIXES = (
    "/mnt/cup/",  # linux (the sorting cluster)
    "/Volumes/",  # macOS
    "//cup.pni.princeton.edu/",  # windows, UNC forward-slash form
    "\\\\cup.pni.princeton.edu\\\\",  # windows, UNC backslash form
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
    # Windows reads /mnt/... as drive-relative, not absolute.
    if dat_path.startswith("/"):
        return True
    if re.match(r"^[A-Za-z]:[\\/]", dat_path):  # C:\... or C:/...
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
        tail = normalized[len(pfx) :]
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
    print(
        f"Rewrote dat_path for this platform: {dat_paths[0]} -> {replacements[0]}",
        file=sys.stderr,
    )
    return tmp


def _install_font_fallback() -> None:
    """Stop phy crashing when Qt refuses its bundled icon font.

    phy's _load_font registers fa-solid-900.ttf (Font Awesome, used for the
    dock title-bar buttons) and indexes applicationFontFamilies(font_id)[0].
    If Qt cannot register the file, font_id is -1, the list is empty, and phy
    dies with IndexError before the window opens. This happens on Windows
    machines that block untrusted fonts (fonts loaded from outside
    %windir%\\Fonts), a common managed-machine policy.

    The replacement tries the file, then the same bytes from memory, which
    goes through a different Windows API, and finally settles for the default
    font. The last case costs only the glyphs on the dock buttons, which is
    much better than no GUI at all.
    """
    from phy.gui import gui as phy_gui
    from phy.gui import qt as phy_qt
    from PyQt5.QtGui import QFont, QFontDatabase

    def families(font_id: int) -> list[str]:
        return QFontDatabase.applicationFontFamilies(font_id) if font_id >= 0 else []

    def load_font(name, size=8):
        if name in phy_qt._FONTS:
            return phy_qt._FONTS[name]
        path = phy_qt._static_abs_path(name)
        found = families(QFontDatabase.addApplicationFont(str(path)))
        if not found and path.is_file():
            found = families(
                QFontDatabase.addApplicationFontFromData(path.read_bytes())
            )
        if found:
            font = QFontDatabase().font(found[0], None, size)
        else:
            print(
                f"Note: Qt could not load phy's icon font {name}; dock buttons "
                "will show placeholder glyphs.",
                file=sys.stderr,
            )
            font = QFont()
            font.setPointSize(size)
        phy_qt._FONTS[name] = font
        return font

    # gui.py binds the name at import, so patch it there as well.
    phy_qt._load_font = load_font
    phy_gui._load_font = load_font


#: Windows' MAX_PATH. A process that is not long-path aware (or runs where
#: LongPathsEnabled is 0) cannot open a path of this many characters or more.
MAX_PATH = 260

#: Room joblib needs below phy's .phy cache directory. The deepest writes seen
#: on a real session were 124 characters (func_code.py temp files under
#: TemplateMixin\\get_spike_template_amplitudes); the rest is headroom for
#: longer pids and thread ids, and for joblib versions that add a joblib\\ level.
CACHE_DEPTH = 160


def _long_paths_enabled() -> bool:
    """True if Windows is configured to allow paths beyond MAX_PATH."""
    if sys.platform != "win32":
        return False
    import winreg

    try:
        with winreg.OpenKey(
            winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Control\FileSystem"
        ) as key:
            value, _ = winreg.QueryValueEx(key, "LongPathsEnabled")
    except OSError:
        return False
    return value == 1


def _cache_too_deep(dir_path: str, *, windows: bool, long_paths: bool) -> bool:
    """True if phy's cache under dir_path would run past MAX_PATH."""
    if not windows or long_paths or not dir_path:
        return False
    return len(dir_path) + len("\\.phy") + CACHE_DEPTH >= MAX_PATH


def _extended_path(path: str) -> str:
    """Return the \\\\?\\ extended-length form of an absolute Windows path.

    \\\\?\\ tells Windows to skip path normalisation, which is what lifts
    MAX_PATH -- but it also means '/', '.' and '..' are no longer interpreted,
    so they are resolved here first.
    """
    if path.startswith("\\\\?\\"):
        return path
    p = ntpath.normpath(path.replace("/", "\\")) if path else ""
    if p.startswith("\\\\"):
        return "\\\\?\\UNC\\" + p[2:]
    if re.match(r"^[A-Za-z]:\\", p):
        return "\\\\?\\" + p
    raise ValueError(f"Not an absolute Windows path: {path!r}")


def _install_cache_redirect(cache_dir: Path) -> None:
    """Make phy put its cache in cache_dir instead of <dir_path>\\.phy.

    Mirrors BaseController._set_cache with only the location changed.
    """
    from phy.apps.base import BaseController
    from phy.utils.context import Context

    def _set_cache(self, clear_cache=None):
        self.cache_dir = Path(cache_dir)
        if clear_cache:
            self._clear_cache()
        self.context = Context(self.cache_dir)

    BaseController._set_cache = _set_cache


def main(argv: list[str]) -> int:
    data_dir = Path(argv[0]).expanduser() if argv else Path.cwd()

    if not data_dir.is_dir():
        print(f"Not a directory: {data_dir}", file=sys.stderr)
        return 1

    # params.py is what kilosort writes. The old .BAT used win_params.py, a copy
    # the sorter adds with the share prefix rewritten for Windows; it is absent
    # for sessions sorted before that was added, and _localize_params does the
    # same rewrite on every platform.
    params = data_dir / "params.py"
    if not params.is_file():
        print(
            f"No params.py in {data_dir}; is this a kilosort output directory?",
            file=sys.stderr,
        )
        return 1

    params = _localize_params(data_dir, params)

    if _cache_too_deep(
        str(data_dir.absolute()),
        windows=sys.platform == "win32",
        long_paths=_long_paths_enabled(),
    ):
        cache_dir = _extended_path(str(data_dir.absolute() / ".phy"))
        print(
            f"Note: phy's cache path is past MAX_PATH; using {cache_dir}",
            file=sys.stderr,
        )
        _install_cache_redirect(Path(cache_dir))

    _install_font_fallback()
    template_gui(params)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
