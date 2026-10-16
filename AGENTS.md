# RecordingProcessJobGUI

A MATLAB GUI (compiled for Windows recording rigs) that registers ephys and
imaging recordings in the automatic pipeline, and launches phy, suite2p and the
IBL atlas through PEP 723 scripts in `PythonScripts/`. MATLAB plus Python via uv.

## Tests

```bash
uv run --isolated --no-project --with phy --with pytest pytest PythonScripts/tests
uv run --no-cache --script tests/test_open_phy_dat_path.py
uv run --no-cache --script tests/test_iblapps_version.py
uv run --no-cache --script tests/test_matlab_export.py
```

MATLAB tests: `runtests({'tests/TestBuildUvScriptCall.m', 'tests/TestOutputDirMatch.m'})`
with the repo on the path. CI runs Python on ubuntu and windows, because rigs run
Windows and `open_phy.py` handles UNC and long paths.

Lint: `uvx prek run --all-files` (the same as CI's Lint workflow).

## Pins and gotchas

- `datajoint==0.14.10` exactly.
- The vendored MATLAB toolboxes (`mym-mariadbconn/`, `modDataJoint/`, `GHToolbox/`,
  ...) are third-party: no hook touches them, and don't edit them.
- `PythonScripts/dj_local_conf.json` carries a live DB password for the compiled
  build. Don't copy it anywhere or add more secrets.

## Agent workflow

- Errors reported in Slack: use the `bugfix-from-slack` skill (agent-tooling). The agent files nothing itself: commits, pushes and PRs are the user's.
- Commits end with one `Assisted-by: <Harness>:<model>` trailer per agent, e.g. `Assisted-by: ClaudeCode:claude-opus-5-5`. No AI co-authors, and no `Generated with` lines. `prek install` sets up the `ai-attribution` commit-msg hook (`.github/scripts/check_ai_attribution.py`, vendored from agent-tooling), and CI checks every commit of a PR.
- PRs target `main` on `BrainCOGS/RecordingProcessJobGUI`, opened from the user's own account.
