# RecordingProcessJobGUI
GUI to register recordings in the automatic pipeline

## Installation

### Installation on a Windows

See the instructions [here](https://braincogs.github.io/software/configure_systems.html#configure-new-recording-system). Ensure that all the information under the "System Configuration" tab is entered correctly otherwise your behavior data may not show up.

### Installation on Mac/Linux

```bash
git clone git@github.com:BrainCOGS/RecordingProcessJobGUI.git --recurse-submodules
```

That is the whole install. There is no conda environment to build: the app
locates [uv](https://docs.astral.sh/uv/) at startup, installing it if it is
missing, and every python tool it shells out to declares its own dependencies.

- The parameter helpers (`read_params.py`, `upload_params.py`) run against the
  repo's `pyproject.toml`.
- The external GUIs — phy, suite2p and the IBL atlas — are standalone launchers
  in `PythonScripts/` carrying inline [PEP 723](https://peps.python.org/pep-0723/)
  dependency blocks, so uv provisions each one into its own cached environment
  the first time that button is pressed. Expect that first launch to be slow
  while the environment is built; later launches reuse the cache.

If uv cannot be found or installed, the GUI still runs — the parameter helpers
fall back to a MATLAB-only path, and the external GUI buttons report that uv is
missing instead of failing obscurely.
