# /// script
# requires-python = ">=3.12"
# dependencies = ["phy"]
# ///
"""Launch the phy template GUI on a kilosort output directory.

Cross-platform replacement for open_phy.BAT, which was cmd.exe-only (MATLAB's
system() on macOS handed it to zsh, which refused it outright) and additionally
assumed phy lived in a conda env named on the command line.

The dependency block above is inline PEP 723 metadata, so

    uv run --no-project PythonScripts/open_phy.py <sorting_output_dir>

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

The directory argument is optional and defaults to the current working
directory, matching the old .BAT, which relied on the caller's cd.
"""

from __future__ import annotations

import sys
from pathlib import Path

from phy.apps.template import template_gui


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

    template_gui(params)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
