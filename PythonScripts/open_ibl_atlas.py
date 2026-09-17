# /// script
# requires-python = ">=3.12"
# dependencies = ["iblapps", "iblatlas", "setuptools"]
#
# [tool.uv.sources]
# # The GUI itself, straight from upstream. Pinned to a revision rather than a
# # branch so a launch months from now resolves what was tested here; bump the
# # rev deliberately to take upstream changes.
# iblapps = { git = "https://github.com/int-brain-lab/iblapps.git", rev = "b46a532c80079bbdbb0e45ef1fc10e9eb4d767ae" }
#
# [tool.uv]
# # iblapps' requirements.txt pins PyQt5==5.12.3, which publishes no Apple
# # Silicon wheel, so resolution fails outright on any arm64 Mac. Overriding it
# # is what lets the package be installed unmodified; it resolves to 5.15.x,
# # which is what working installs of this GUI run today.
# override-dependencies = ["pyqt5>=5.15"]
# ///
"""Launch the IBL electrophysiology atlas GUI on a job's ibl_data directory.

Replaces the old `<iblenv python> ephys_atlas_gui.py ...` invocation, which
required a hand-built conda env. Running under uv

    uv run --no-project PythonScripts/open_ibl_atlas.py -o True -d <ibl_data>

provisions the whole stack on demand, on any platform, with no conda anywhere.
uv always runs a PEP 723 script in isolation, so this never picks up the repo's
own pyproject.toml.

Why upstream git rather than the vendored copy
----------------------------------------------
PythonScripts/iblapps-master/ is a snapshot of an old iblapps, written against
an IBL API surface that has since moved: running it needs ibllib<2.15 (4.x
dropped ibllib.atlas, and 2.40 had already removed the brainbox.io.spikeglx
symbol its plot_data imports), ONE-api<3, ibl-neuropixel<1, scipy<1.13 and
setuptools<81. That pin stack also caps the interpreter at 3.12, because
scipy<1.13 ships no wheels for 3.13+.

Upstream master has kept pace with those API moves, so installing it directly
needs none of those pins and runs on current packages. Verified importing
atlaselectrophysiology.ephys_atlas_gui on python 3.14.7 with ibllib 4.0.1,
ONE-api 3.5.2, iblatlas 1.2.1, scipy 1.18.1, numpy 2.3.5, PyQt5 5.15.14.

iblatlas is listed explicitly because iblapps imports it while ibllib 4.x no
longer pulls it in; setuptools because parts of the IBL stack still import
pkg_resources, which was dropped from the stdlib in 3.12.

The `iblapps` package on PyPI is a stale 0.0.1 placeholder that does not import
(it expects a top-level `qt` module that is not packaged), so it is not usable.

Longer term, upstream has replaced iblapps with int-brain-lab/ibl-alignment-gui.
That project is not used here yet: as of this change it has no PyPI release and
pulls a dependency from a git URL. When it stabilises, this launcher is the
single file that has to change.
"""

from __future__ import annotations

import argparse
import os
import platform
import sys
from pathlib import Path


def main(argv: list[str]) -> int:
    # Carried over from ephys_atlas_gui.py's own preamble: Big Sur needs this
    # set before the first Qt import or the window renders blank.
    if platform.system() == "Darwin" and platform.release().split(".")[0] == "20":
        os.environ["QT_MAC_WANTS_LAYER"] = "1"

    from PyQt5 import QtWidgets

    from atlaselectrophysiology.ephys_atlas_gui import MainWindow

    parser = argparse.ArgumentParser(description="IBL electrophysiology atlas GUI")
    parser.add_argument("-o", "--offline", default=False, required=False,
                        help="Offline mode")
    parser.add_argument("-i", "--insertion", default=None, required=False,
                        help="Insertion mode")
    parser.add_argument("-d", "--directory", default=None, required=False,
                        help="Data directory")
    args = parser.parse_args(argv)

    # No -r/--remote: current MainWindow.__init__ does not take it. The old
    # vendored copy did, and passing it raises TypeError, so it is dropped
    # rather than forwarded. The MATLAB caller never sent it.
    app = QtWidgets.QApplication([])
    mainapp = MainWindow(offline=args.offline, probe_id=args.insertion)

    # Mirrors the __main__ block of ephys_atlas_gui.py, which assumed -d was
    # always given and raised an opaque TypeError when it was not.
    if args.directory is not None:
        folder_path = Path(args.directory)
        if not folder_path.is_dir():
            print(f"Not a directory: {folder_path}", file=sys.stderr)
            return 1
        mainapp.folder_line.setText(str(folder_path))
        try:
            mainapp.prev_alignments, shank_options = \
                mainapp.loaddata.get_info(folder_path)
        except FileNotFoundError as exc:
            # get_info reads the ONE/ALF files the conversion step writes. A
            # directory that has not been converted yet raises deep inside
            # numpy; report which file was missing instead of a traceback.
            print(f"{folder_path} does not look like a converted ibl_data "
                  f"directory: missing {Path(exc.filename).name}",
                  file=sys.stderr)
            return 1
        mainapp.populate_lists(shank_options, mainapp.shank_list,
                               mainapp.shank_combobox)
        mainapp.populate_lists(mainapp.prev_alignments, mainapp.align_list,
                               mainapp.align_combobox)
        mainapp.on_shank_selected(0)
        mainapp.data_button_pressed()

    mainapp.show()
    return app.exec_()


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
