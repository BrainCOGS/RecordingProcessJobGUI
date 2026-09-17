# /// script
# requires-python = ">=3.10"
# dependencies = ["phy==2.1.0"]
# ///
"""Launch the phy template GUI on a kilosort output directory.

Cross-platform replacement for open_phy.BAT, which was cmd.exe-only (MATLAB's
system() on macOS handed it to zsh, which refused it) and additionally assumed
phy lived in a conda env named on the command line.

The dependency block above is inline PEP 723 metadata, so

    uv run PythonScripts/open_phy.py <sorting_output_dir>

resolves phy into its own cached environment on first use and reuses it after
that. No conda, and no entry in the root pyproject.toml: phy pulls its own Qt
stack and pins numpy<2, so it cannot share the helper-script environment.

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

    params = data_dir / "params.py"
    if not params.is_file():
        print(f"No params.py in {data_dir}; is this a kilosort output directory?",
              file=sys.stderr)
        return 1

    template_gui(params)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
