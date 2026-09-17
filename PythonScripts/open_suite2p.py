# /// script
# requires-python = ">=3.10"
# dependencies = ["suite2p[gui]==1.1.0"]
# ///
"""Launch the suite2p GUI, optionally loading a processing output directory.

Cross-platform replacement for open_suite2p.BAT. As with open_phy.py the
dependency block is inline PEP 723 metadata, so

    uv run PythonScripts/open_suite2p.py [output_dir]

resolves suite2p into its own cached environment -- no conda.

suite2p 1.1.0 reads the older output layouts this pipeline has produced
(ops/stat/F/Fneu/spks/iscell written with allow_pickle), and treats an absent
optional redcell.npy as "no channel 2" rather than an error, so pinning the
current release does not strand existing results.

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
