# RecordingProcessJobGUI
GUI to register recordings in the automatic pipeline

## Installation

### Installation on a Windows

See the instructions [here](https://braincogs.github.io/software/configure_systems.html#configure-new-recording-system)

### Installation on Mac/Linux

```bash
conda update -n base -c defaults conda
conda create --name iblenv python=3.12 --yes
conda activate iblenv
git clone git@github.com:BrainCOGS/RecordingProcessJobGUI.git --recurse-submodules
pip install --editable RecordingProcessJobGUI/PythonScripts/iblapps-master
git clone https://github.com/int-brain-lab/iblenv
cd iblenv
pip install --requirement requirements.txt
```
