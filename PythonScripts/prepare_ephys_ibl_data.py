# /// script
# requires-python = ">=3.12"
# dependencies = ["iblapps", "iblatlas", "ibllib", "phylib", "numpy", "setuptools"]
#
# [tool.uv.sources]
# # atlaselectrophysiology.extract_files lives in iblapps. BrainCOGS' fork, not
# # upstream: it carries a local change to extract_files.rmsmap. Tracked by
# # branch, matching open_ibl_atlas.py. This used to come from an editable
# # install of an in-tree copy inside the iblenv conda env.
# iblapps = { git = "https://github.com/BrainCOGS/iblapps.git", branch = "master" }
#
# [tool.uv]
# # iblapps pins PyQt5==5.12.3, which has no Apple Silicon wheel.
# override-dependencies = ["pyqt5>=5.15"]
# ///
"""Convert a kilosort output directory to IBL (ONE) format.

Run by hand, not from the GUI:

    uv run --script PythonScripts/prepare_ephys_ibl_data.py

The ks_path / ephys_path / out_path constants below are hardcoded to one
session and must be edited before each run.

Previously this needed the iblenv conda env plus an editable install of the
in-tree iblapps copy. Both are gone; the dependency block above provisions
everything through uv instead.
"""


from pathlib import Path
# spikeglx moved out of ibllib.io into its own top-level module, provided by
# ibl-neuropixel.
import spikeglx
from atlaselectrophysiology.extract_files import extract_data, extract_rmsmap, _sample2v 
import ibllib.ephys.ephysqc as ephysqc
from phylib.io import alf
import numpy as np
import os

# Paths
# Path to KS2 output
#ks_path = Path(r'/Volumes/braininit/Data/Processed/electrophysiology/ms81/ms81_651/20220715/T4_Zhihao_g0/T4_Zhihao_g0_imec0/job_id_203/kilosort_output')
ks_path = Path(r'/Volumes/braininit/Data/Processed/electrophysiology/ms81/ms81_651/20220715/T4_Zhihao_g0/T4_Zhihao_g0_imec1/job_id_206/kilosort_output')

# Path to raw ephys data
#ephys_path = Path(r'/Volumes/braininit/Data/Raw/electrophysiology/ms81/ms81_651/20220715/T4_Zhihao_g0/T4_Zhihao_g0_imec0/')
ephys_path = Path(r'/Volumes/braininit/Data/Raw/electrophysiology/ms81/ms81_651/20220715/T4_Zhihao_g0/T4_Zhihao_g0_imec1/')


# Save path
out_path = Path(r'/Volumes/braininit/Shared/iblGUI_output')

# STEP 1: Load KS data and convert to ALF files
ap_bin_path = list(ephys_path.glob('*.ap.bin'))[0]
#ap_bin_path = list(ephys_path.glob('tmp_wh.dat'))[0]
lf_bin_path = list(ephys_path.glob('*.lf.bin'))[0]
m = ephysqc.phy_model_from_ks2_path(ks_path, ephys_path, ap_bin_path)
ac = alf.EphysAlfCreator(m)
ac.convert(out_path, force=True, ampfactor=_sample2v(ap_bin_path))

# STEP 2: SAVE AP & LF RMSMAP
extract_rmsmap(ap_bin_path, out_folder=out_path, spectra=False)
extract_rmsmap(lf_bin_path, out_folder=out_path)

# STEP 3: Cluster metrics, using the spike depths computed already
spike_depths = np.load(out_path / 'spikes.depths.npy');
m.depths = spike_depths
ephysqc.spike_sorting_metrics_ks2(ks_path, m, save=True)
os.rename(ks_path.joinpath('cluster_metrics.csv'), out_path.joinpath('cluster_metrics.csv'))

print('All done')