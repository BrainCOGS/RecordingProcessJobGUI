"""Report when the installed iblapps is behind the branch it tracks.

The atlas launchers install iblapps from BrainCOGS/iblapps by branch rather
than by commit, so a fix merged to the fork reaches the GUI without a matching
commit in this repo. uv resolves the branch tip when it first builds the
environment and then reuses that build, so a merge lands only on the next
rebuild -- which may be weeks later, or never, if nothing invalidates the
cache.

That is the tradeoff of tracking a branch: it removes the stale-pin failure
mode (a fix that cannot arrive without a commit here) and replaces it with a
quieter one (a fix that has arrived upstream but is not installed). This module
makes the second one visible instead of silent.

It is advisory only. It never blocks a launch, never installs anything, and
swallows every error -- no network, no git, a private repo, a detached CI
runner -- because failing to check for an update must not stop the GUI opening.

Used by open_ibl_atlas.py and prepare_ephys_ibl_data.py.
"""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

#: Where the launchers install iblapps from. Must match [tool.uv.sources] in
#: their PEP 723 headers; check_for_update() verifies that rather than assuming.
IBLAPPS_URL = "https://github.com/BrainCOGS/iblapps.git"
IBLAPPS_BRANCH = "master"

#: git ls-remote is a single round trip against the remote's ref advertisement,
#: no clone. Short timeout: this runs before a GUI the user is waiting on.
_LS_REMOTE_TIMEOUT_S = 5


def installed_commit(package: str = "iblapps") -> str | None:
    """Return the commit of an installed VCS package, or None.

    pip and uv both record the resolved revision in direct_url.json (PEP 610)
    when a distribution is installed from a VCS URL, which is exactly what the
    branch install produces. Reading it costs nothing and needs no network.
    """
    try:
        from importlib.metadata import distribution

        dist = distribution(package)
    except Exception:
        return None

    try:
        raw = dist.read_text("direct_url.json")
        if not raw:
            return None
        info = json.loads(raw).get("vcs_info") or {}
        commit = info.get("commit_id")
        return commit if isinstance(commit, str) and commit else None
    except Exception:
        return None


def remote_commit(url: str = IBLAPPS_URL, branch: str = IBLAPPS_BRANCH) -> str | None:
    """Return the branch tip on the remote, or None if it cannot be reached."""
    try:
        proc = subprocess.run(
            ["git", "ls-remote", url, f"refs/heads/{branch}"],
            capture_output=True,
            text=True,
            timeout=_LS_REMOTE_TIMEOUT_S,
        )
    except Exception:
        # No git, no network, DNS failure, or slower than the timeout.
        return None

    if proc.returncode != 0 or not proc.stdout.strip():
        return None

    sha = proc.stdout.split(maxsplit=1)[0].strip()
    # A ref advertisement is "<40-hex sha>\t<ref>"; anything else is not one.
    return sha if len(sha) == 40 and all(c in "0123456789abcdef" for c in sha) else None


def tracked_source(script: Path) -> tuple[str, str] | None:
    """Read the git url and branch a launcher's PEP 723 header declares.

    Parsed rather than assumed, so this cannot drift from the header and start
    comparing against the wrong repository. Returns None when the header pins a
    commit instead of a branch, in which case there is nothing to be behind.
    """
    try:
        text = script.read_text()
    except Exception:
        return None

    import re

    m = re.search(
        r'iblapps\s*=\s*\{[^}]*?git\s*=\s*"([^"]+)"[^}]*?branch\s*=\s*"([^"]+)"',
        text,
    )
    if not m:
        return None
    return m.group(1), m.group(2)


def check_for_update(script: Path | None = None, stream=sys.stderr) -> bool:
    """Print a note when the installed iblapps is behind its branch.

    Returns True when an update is available, False otherwise -- including
    every case where the answer could not be determined. Callers use the
    return value for tests; the user-facing effect is the printed note.
    """
    try:
        url, branch = IBLAPPS_URL, IBLAPPS_BRANCH
        if script is not None:
            declared = tracked_source(script)
            if declared is None:
                # Header pins a commit, or could not be read: nothing to check.
                return False
            url, branch = declared

        have = installed_commit()
        want = remote_commit(url, branch)

        if not have or not want or have == want:
            return False

        print(
            f"Note: a newer iblapps is available on {branch} "
            f"({want[:8]}; this environment has {have[:8]}).\n"
            f"      Run `uv cache clean iblapps` to pick it up on the next launch.",
            file=stream,
        )
        return True
    except Exception:
        # Advisory only -- never let this stop the GUI opening.
        return False
