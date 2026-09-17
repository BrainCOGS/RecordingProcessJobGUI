"""Tests for the savemat sanitising helpers in PythonScripts/matlab_export.py."""

import json
import os
import sys
import warnings

import pytest
from scipy.io import loadmat, savemat

sys.path.insert(
    0, os.path.join(os.path.dirname(__file__), os.pardir, "PythonScripts")
)

from matlab_export import matlab_field_name, matlab_safe  # noqa: E402

REPO_ROOT = os.path.join(os.path.dirname(__file__), os.pardir)
SUITE2P_PARAMS = os.path.join(REPO_ROOT, "Original_Params_DB", "suite2p_params.json")


def save_and_load(obj, tmp_path):
    """savemat/loadmat a dict, failing if savemat warns about a dropped field."""
    path = str(tmp_path / "params.mat")
    with warnings.catch_warnings():
        # MatWriteWarning means a field was silently dropped - that is the bug.
        warnings.simplefilter("error")
        savemat(path, obj)
    return loadmat(path)


class TestMatlabFieldName:
    def test_leading_digit_is_prefixed(self):
        assert matlab_field_name("1Preg") == "x1Preg"

    def test_leading_underscore_is_prefixed(self):
        assert matlab_field_name("_private") == "x_private"

    def test_ordinary_name_is_unchanged(self):
        assert matlab_field_name("tau") == "tau"

    def test_digit_later_in_name_is_unchanged(self):
        assert matlab_field_name("suite2p") == "suite2p"

    def test_trailing_underscore_is_unchanged(self):
        assert matlab_field_name("tau_") == "tau_"

    def test_empty_string_is_unchanged(self):
        assert matlab_field_name("") == ""

    def test_all_digits(self):
        assert matlab_field_name("0") == "x0"

    def test_non_string_key_is_unchanged(self):
        assert matlab_field_name(3) == 3
        assert matlab_field_name(None) is None


class TestMatlabSafeNone:
    def test_bare_none_becomes_empty_list(self):
        assert matlab_safe(None) == []

    def test_none_value_in_dict(self):
        assert matlab_safe({"fast_disk": None}) == {"fast_disk": []}

    def test_none_nested_in_list(self):
        assert matlab_safe({"a": [1, None, 3]}) == {"a": [1, [], 3]}

    def test_none_in_tuple_keeps_tuple_type(self):
        result = matlab_safe(("a", None))
        assert result == ("a", [])
        assert isinstance(result, tuple)

    def test_falsy_values_are_not_treated_as_none(self):
        # 0, False and "" must survive untouched - only None becomes [].
        params = {"nplanes": 0, "delete_bin": False, "h5py_key": "", "tau": 0.0}
        assert matlab_safe(params) == params


class TestMatlabSafeFieldNames:
    def test_leading_digit_key_is_renamed(self):
        assert matlab_safe({"1Preg": False}) == {"x1Preg": False}

    def test_rename_preserves_value(self):
        assert matlab_safe({"1Preg": True})["x1Preg"] is True

    def test_nested_dict_keys_are_renamed(self):
        record = {"params": {"1Preg": False, "tau": 1.0}}
        assert matlab_safe(record) == {"params": {"x1Preg": False, "tau": 1.0}}

    def test_keys_inside_list_of_dicts_are_renamed(self):
        record = {"steps": [{"1Preg": 1}, {"tau": 2}]}
        assert matlab_safe(record) == {"steps": [{"x1Preg": 1}, {"tau": 2}]}

    def test_renamed_key_with_none_value(self):
        assert matlab_safe({"1Preg": None}) == {"x1Preg": []}

    def test_empty_dict_is_preserved(self):
        assert matlab_safe({}) == {}


class TestSavematRoundTrip:
    """The regression: these fields must survive savemat, not be dropped."""

    def test_leading_digit_field_survives_savemat(self, tmp_path):
        record = {"param_0": matlab_safe({"params": {"1Preg": False, "tau": 1.0}})}
        loaded = save_and_load(record, tmp_path)
        fields = loaded["param_0"]["params"][0, 0].dtype.names
        assert "x1Preg" in fields
        assert "tau" in fields

    def test_unsanitised_field_is_dropped_by_scipy(self, tmp_path):
        """Documents the scipy behaviour the sanitising works around."""
        path = str(tmp_path / "raw.mat")
        with pytest.warns(UserWarning, match="1Preg"):
            savemat(path, {"param_0": {"1Preg": False, "tau": 1.0}})
        assert loadmat(path)["param_0"].dtype.names == ("tau",)

    def test_suite2p_paramset_round_trips(self, tmp_path):
        """The real paramset that produced the warning."""
        with open(SUITE2P_PARAMS) as handle:
            params = json.load(handle)
        assert "1Preg" in params, "fixture no longer covers the bug"

        loaded = save_and_load({"param_0": matlab_safe({"params": params})}, tmp_path)
        fields = loaded["param_0"]["params"][0, 0].dtype.names
        assert "x1Preg" in fields
        # Every key in the source paramset must be present under some name.
        assert len(fields) == len(params)

    def test_none_values_round_trip(self, tmp_path):
        record = {"param_0": matlab_safe({"params": {"fast_disk": None, "tau": 1.0}})}
        loaded = save_and_load(record, tmp_path)
        assert loaded["param_0"]["params"][0, 0]["fast_disk"][0, 0].size == 0
