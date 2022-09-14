from pathlib import Path
from ibllib.io import spikeglx
from atlaselectrophysiology.extract_files import extract_data, extract_rmsmap, _sample2v 
import ibllib.ephys.ephysqc as ephysqc
from phylib.io import alf
import numpy as np
import os
import sys

# Paths
# Path to KS2 output
#ks_path = Path(r'/Volumes/braininit/Data/Processed/electrophysiology/ms81/ms81_651/20220715/T4_Zhihao_g0/T4_Zhihao_g0_imec0/job_id_203/kilosort_output')
def prepare_data(ephys_path, ks_path, output_path):


    ks_path = Path(ks_path)
    ephys_path = Path(ephys_path)
    # Save path
    out_path = Path(output_path)

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

if __name__ == "__main__":
    args = sys.argv[1:]
    print(args)

    prepare_data(args[0], args[1], args[2])