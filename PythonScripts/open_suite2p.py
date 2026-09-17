# /// script
# requires-python = ">=3.12"
# dependencies = ["suite2p[gui]"]
# ///
"""Launch the suite2p GUI, optionally loading a processing output directory.

Cross-platform replacement for open_suite2p.BAT. As with open_phy.py the
dependency block is inline PEP 723 metadata, so

    uv run --no-project PythonScripts/open_suite2p.py [output_dir]

resolves suite2p into its own cached environment -- no conda, and no entry in
the repo's pyproject.toml, since uv runs a PEP 723 script in isolation.

Python floor
------------
`>=3.12`: suite2p and its torch/PyQt6 stack publish 3.14 wheels. Verified
importing suite2p.gui.gui2p on 3.14.7 (suite2p 1.1.0, torch 2.14.0, numpy
2.5.3). The GUI extra resolves to PyQt6 on current releases; nothing here
depends on which Qt binding is selected.

Note the extra is spelled suite2p[gui]. MATLAB's system() hands the command to
the user's shell, and zsh treats unquoted brackets as a glob and aborts with
"no matches found" -- the MATLAB side quotes the whole script path, and this
requirement lives in the file rather than on the command line, so the bracket
never reaches the shell at all.

If output_dir contains a suite2p/plane0/stat.npy, it is passed to the GUI so it
opens on that dataset; otherwise the GUI starts empty and the user picks a
folder. The old .BAT always started empty and relied on the caller's cd.
"""

from __future__ import annotations

import sys
from pathlib import Path


def find_stat(data_dir: Path) -> Path | None:
    """Locate a stat.npy under data_dir, tolerating the usual nesting levels."""
    candidates = [
        data_dir / "stat.npy",
        data_dir / "plane0" / "stat.npy",
        data_dir / "suite2p" / "plane0" / "stat.npy",
    ]
    for candidate in candidates:
        if candidate.is_file():
            return candidate
    return None


def main(argv: list[str]) -> int:
    data_dir = Path(argv[0]).expanduser() if argv else Path.cwd()

    stat_file = find_stat(data_dir) if data_dir.is_dir() else None

    from suite2p.gui import gui2p

    gui2p.run(statfile=str(stat_file) if stat_file else None)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
