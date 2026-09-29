# RecordingProcessJobGUI
GUI to register recordings in the automatic pipeline

## Installation

### Installation on a Windows

See the instructions [here](https://braincogs.github.io/software/configure_systems.html#configure-new-recording-system). Ensure that all the information under the "System Configuration" tab is entered correctly otherwise your behavior data may not show up.

### Windows installer (no MATLAB needed)

Every push to `main` builds a standalone Windows app and publishes it on the
[releases page](https://github.com/BrainCOGS/RecordingProcessJobGUI/releases/latest).
Download `Recording_Automation_GUI_Installer.exe` and run it. If the machine
doesn't have the free MATLAB Runtime, the installer downloads it. MATLAB itself
isn't required.

The build bundles the latest [uv](https://docs.astral.sh/uv/), so the python
tools work on a rig that never installed it. If uv is already installed on the
machine, the app uses that copy instead.

The compiled app stores the rig's System Configuration in
`%APPDATA%\RecordingProcessJobGUI\system_conf_job_gui.json`, so the
configuration is kept when the app is updated.

The build is `.github/workflows/windows-release.yml`, which runs
`build/buildWindowsApp.m`. You can run the same script on a Windows machine
that has MATLAB Compiler. The workflow needs a MATLAB batch licensing token in
the `MLM_LICENSE_TOKEN` repository secret, because GitHub's free MATLAB license
doesn't cover MATLAB Compiler.

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

## Tests

The python suites declare their own dependencies inline (PEP 723), so they need
no environment set up first:

```bash
uv run --script tests/test_matlab_export.py
uv run --script tests/test_open_phy_dat_path.py
```

The MATLAB suites are `matlab.unittest` classes and run through `runtests`:

```bash
matlab -batch "addpath(pwd); runtests({'tests/TestBuildUvScriptCall.m','tests/TestOutputDirMatch.m','tests/TestBundledUvPath.m','tests/TestResolveConfFile.m'})"
```

`tests/test_jsonencodepretty.m` is a plain script with bare asserts rather than
a test class, so `runtests` cannot collect it. Call it by name:

```bash
matlab -batch "addpath(pwd); addpath([pwd filesep 'tests']); test_jsonencodepretty"
```
