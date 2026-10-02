"""Regression tests for phy's icon-font load failing on Windows.

phy's _load_font indexes QFontDatabase.applicationFontFamilies(font_id)[0].
When Qt cannot register the bundled Font Awesome file, font_id is -1, the
list is empty, and phy dies with IndexError before the GUI opens.

Run with:

    QT_QPA_PLATFORM=offscreen uv run --with phy --with pytest \
        pytest PythonScripts/tests
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import open_phy  # noqa: E402
from phy.gui import gui as phy_gui  # noqa: E402
from phy.gui import qt as phy_qt  # noqa: E402
from PyQt5.QtGui import QFont, QFontDatabase  # noqa: E402
from PyQt5.QtWidgets import QApplication  # noqa: E402

FONT = "fa-solid-900.ttf"


@pytest.fixture(scope="module")
def qapp():
    return QApplication.instance() or QApplication([])


@pytest.fixture(autouse=True)
def fresh_font_state(monkeypatch):
    """Isolate each test from phy's font cache and from our patch."""
    monkeypatch.setattr(phy_qt, "_FONTS", {})
    monkeypatch.setattr(phy_qt, "_load_font", phy_qt._load_font)
    monkeypatch.setattr(phy_gui, "_load_font", phy_gui._load_font)


def _fail_file_load(monkeypatch):
    monkeypatch.setattr(
        QFontDatabase, "addApplicationFont", staticmethod(lambda path: -1)
    )


def _fail_data_load(monkeypatch):
    monkeypatch.setattr(
        QFontDatabase, "addApplicationFontFromData", staticmethod(lambda data: -1)
    )


def test_unpatched_phy_crashes_when_font_rejected(qapp, monkeypatch):
    """Documents the upstream bug the patch works around."""
    _fail_file_load(monkeypatch)
    with pytest.raises(IndexError):
        phy_qt._load_font(FONT)


def test_normal_load_still_uses_font_awesome(qapp):
    open_phy._install_font_fallback()
    font = phy_qt._load_font(FONT)
    assert "Font Awesome" in font.family()


def test_falls_back_to_loading_from_memory(qapp, monkeypatch):
    _fail_file_load(monkeypatch)
    open_phy._install_font_fallback()
    font = phy_qt._load_font(FONT)
    assert "Font Awesome" in font.family()


def test_falls_back_to_default_font_when_all_loads_fail(qapp, monkeypatch, capsys):
    _fail_file_load(monkeypatch)
    _fail_data_load(monkeypatch)
    open_phy._install_font_fallback()
    font = phy_qt._load_font(FONT)
    assert isinstance(font, QFont)
    assert "Font Awesome" not in font.family()
    assert FONT in capsys.readouterr().err


def test_id_ok_but_no_families_is_treated_as_failure(qapp, monkeypatch):
    """A valid id with an empty family list must not IndexError either."""
    _fail_file_load(monkeypatch)
    _fail_data_load(monkeypatch)
    monkeypatch.setattr(
        QFontDatabase, "addApplicationFont", staticmethod(lambda path: 0)
    )
    monkeypatch.setattr(
        QFontDatabase, "applicationFontFamilies", staticmethod(lambda font_id: [])
    )
    open_phy._install_font_fallback()
    assert isinstance(phy_qt._load_font(FONT), QFont)


def test_missing_font_file_falls_back(qapp, monkeypatch):
    open_phy._install_font_fallback()
    assert isinstance(phy_qt._load_font("does-not-exist.ttf"), QFont)


def test_result_is_cached_and_warns_once(qapp, monkeypatch, capsys):
    calls = []
    monkeypatch.setattr(
        QFontDatabase,
        "addApplicationFont",
        staticmethod(lambda path: calls.append(path) or -1),
    )
    _fail_data_load(monkeypatch)
    open_phy._install_font_fallback()
    first = phy_qt._load_font(FONT)
    second = phy_qt._load_font(FONT)
    assert first == second
    assert len(calls) == 1
    assert capsys.readouterr().err.count(FONT) == 1


def test_dock_widget_constructs_when_font_rejected(qapp, monkeypatch):
    """The exact call from the Windows traceback: DockWidget.__init__."""
    _fail_file_load(monkeypatch)
    _fail_data_load(monkeypatch)
    open_phy._install_font_fallback()
    dock = phy_gui.DockWidget()
    assert isinstance(dock._font, QFont)
