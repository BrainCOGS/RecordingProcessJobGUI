# /// script
# requires-python = ">=3.12"
# dependencies = ["pytest"]
# ///
"""Tests for the iblapps update check in PythonScripts/iblapps_version.py.

The atlas launchers install iblapps by branch, and uv caches the build, so a
fix merged to the fork can sit unnoticed until something invalidates the cache.
The check turns that silence into a printed note.

Its single hard requirement is that it never interferes with launching the GUI:
every failure mode -- no network, no git, unreadable metadata, a header that
pins a commit -- must return False quietly rather than raise. Most of these
tests exist to pin that down.

Run with:

    uv run --script tests/test_iblapps_version.py
"""

from __future__ import annotations

import io
import subprocess
import sys
from pathlib import Path

import pytest

sys.path.insert(
    0, str(Path(__file__).resolve().parent.parent / "PythonScripts")
)

import iblapps_version as iv  # noqa: E402

SHA_A = "a" * 40
SHA_B = "b" * 40


def write_header(tmp_path: Path, body: str) -> Path:
    p = tmp_path / "launcher.py"
    p.write_text(body)
    return p


# --- reading the declared source ------------------------------------------

def test_reads_url_and_branch_from_header(tmp_path):
    p = write_header(tmp_path, '''# /// script
# [tool.uv.sources]
# iblapps = { git = "https://github.com/BrainCOGS/iblapps.git", branch = "master" }
# ///
''')
    assert iv.tracked_source(p) == (
        "https://github.com/BrainCOGS/iblapps.git", "master")


def test_non_default_branch_is_read(tmp_path):
    p = write_header(tmp_path, '''# /// script
# iblapps = { git = "https://example.com/x.git", branch = "develop" }
# ///
''')
    assert iv.tracked_source(p) == ("https://example.com/x.git", "develop")


def test_commit_pin_has_nothing_to_track(tmp_path):
    # A rev pin is reproducible by construction; there is no branch to lag.
    p = write_header(tmp_path, '''# /// script
# iblapps = { git = "https://github.com/BrainCOGS/iblapps.git", rev = "abc123" }
# ///
''')
    assert iv.tracked_source(p) is None


def test_missing_file_is_none(tmp_path):
    assert iv.tracked_source(tmp_path / "nope.py") is None


def test_header_without_iblapps_is_none(tmp_path):
    p = write_header(tmp_path, "# /// script\n# dependencies = []\n# ///\n")
    assert iv.tracked_source(p) is None


# --- remote lookup ---------------------------------------------------------

def test_remote_commit_parses_ls_remote(monkeypatch):
    monkeypatch.setattr(iv.subprocess, "run", lambda *a, **k: subprocess.CompletedProcess(
        a[0], 0, stdout=f"{SHA_A}\trefs/heads/master\n", stderr=""))
    assert iv.remote_commit() == SHA_A


def test_remote_commit_none_when_git_fails(monkeypatch):
    monkeypatch.setattr(iv.subprocess, "run", lambda *a, **k: subprocess.CompletedProcess(
        a[0], 128, stdout="", stderr="fatal: repository not found"))
    assert iv.remote_commit() is None


def test_remote_commit_none_on_timeout(monkeypatch):
    def boom(*a, **k):
        raise subprocess.TimeoutExpired(cmd="git", timeout=5)
    monkeypatch.setattr(iv.subprocess, "run", boom)
    assert iv.remote_commit() is None


def test_remote_commit_none_when_git_missing(monkeypatch):
    def boom(*a, **k):
        raise FileNotFoundError("git")
    monkeypatch.setattr(iv.subprocess, "run", boom)
    assert iv.remote_commit() is None


def test_remote_commit_rejects_non_sha_output(monkeypatch):
    # A proxy or captive portal returning HTML must not be read as a sha.
    monkeypatch.setattr(iv.subprocess, "run", lambda *a, **k: subprocess.CompletedProcess(
        a[0], 0, stdout="<html>login</html>\n", stderr=""))
    assert iv.remote_commit() is None


def test_remote_commit_none_on_empty_branch(monkeypatch):
    # Branch does not exist: ls-remote exits 0 with no output.
    monkeypatch.setattr(iv.subprocess, "run", lambda *a, **k: subprocess.CompletedProcess(
        a[0], 0, stdout="", stderr=""))
    assert iv.remote_commit() is None


# --- the check itself ------------------------------------------------------

def run_check(monkeypatch, tmp_path, have, want, header=True):
    p = write_header(tmp_path, '''# /// script
# iblapps = { git = "https://example.com/x.git", branch = "master" }
# ///
''') if header else None
    monkeypatch.setattr(iv, "installed_commit", lambda *a, **k: have)
    monkeypatch.setattr(iv, "remote_commit", lambda *a, **k: want)
    buf = io.StringIO()
    result = iv.check_for_update(p, stream=buf)
    return result, buf.getvalue()


def test_reports_when_behind(monkeypatch, tmp_path):
    hit, out = run_check(monkeypatch, tmp_path, SHA_A, SHA_B)
    assert hit
    assert SHA_B[:8] in out and SHA_A[:8] in out
    assert "uv cache clean iblapps" in out, "must say how to act on it"


def test_silent_when_current(monkeypatch, tmp_path):
    hit, out = run_check(monkeypatch, tmp_path, SHA_A, SHA_A)
    assert not hit
    assert out == "", "no news should print nothing"


def test_silent_when_remote_unreachable(monkeypatch, tmp_path):
    # Offline is the common case on a rig; it must not produce noise.
    hit, out = run_check(monkeypatch, tmp_path, SHA_A, None)
    assert not hit and out == ""


def test_silent_when_not_installed_from_vcs(monkeypatch, tmp_path):
    hit, out = run_check(monkeypatch, tmp_path, None, SHA_B)
    assert not hit and out == ""


def test_silent_when_header_pins_a_commit(monkeypatch, tmp_path):
    p = write_header(tmp_path, '''# /// script
# iblapps = { git = "https://example.com/x.git", rev = "abc123" }
# ///
''')
    monkeypatch.setattr(iv, "installed_commit", lambda *a, **k: SHA_A)
    monkeypatch.setattr(iv, "remote_commit", lambda *a, **k: SHA_B)
    buf = io.StringIO()
    assert iv.check_for_update(p, stream=buf) is False
    assert buf.getvalue() == ""


def test_never_raises_even_if_everything_breaks(monkeypatch, tmp_path):
    # The whole point: a broken check must not stop the GUI opening.
    def boom(*a, **k):
        raise RuntimeError("kaboom")
    monkeypatch.setattr(iv, "installed_commit", boom)
    monkeypatch.setattr(iv, "remote_commit", boom)
    assert iv.check_for_update(write_header(tmp_path, '''# /// script
# iblapps = { git = "https://example.com/x.git", branch = "master" }
# ///
'''), stream=io.StringIO()) is False


def test_uses_the_url_from_the_header_not_the_default(monkeypatch, tmp_path):
    # Guards against the check silently comparing the wrong repository.
    seen = {}

    def spy(url, branch):
        seen["url"], seen["branch"] = url, branch
        return SHA_B

    p = write_header(tmp_path, '''# /// script
# iblapps = { git = "https://example.com/fork.git", branch = "develop" }
# ///
''')
    monkeypatch.setattr(iv, "installed_commit", lambda *a, **k: SHA_A)
    monkeypatch.setattr(iv, "remote_commit", spy)
    iv.check_for_update(p, stream=io.StringIO())
    assert seen == {"url": "https://example.com/fork.git", "branch": "develop"}


def test_installed_commit_none_for_absent_package():
    assert iv.installed_commit("definitely-not-installed-xyz") is None


if __name__ == "__main__":
    raise SystemExit(pytest.main([__file__, "-q", "--no-header"]))
