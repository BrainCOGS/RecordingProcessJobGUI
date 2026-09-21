"""Helpers for making DataJoint records safe to write with scipy.io.savemat.

Kept separate from read_params.py so they can be imported (and tested) without
opening a DataJoint connection, which read_params.py does at import time.
"""

# MATLAB identifiers cannot start with a digit or an underscore, so scipy's
# savemat silently drops any struct field whose name does. Such keys reach us
# from paramset blobs written by other tools - the suite2p imaging paramset has
# a "1Preg" key - and dropping them means the params the GUI shows the user are
# not the params stored in the database. Prefix them instead so the value
# survives the round trip.
MATLAB_FIELD_PREFIX = "x"


def matlab_field_name(key):
    """Return `key` as a name MATLAB can use as a struct field.

    Keys starting with a digit or an underscore get a leading 'x' (suite2p's
    "1Preg" becomes "x1Preg"); everything else is returned unchanged.
    """
    if not isinstance(key, str) or not key:
        return key
    if key[0].isdigit() or key[0] == "_":
        return MATLAB_FIELD_PREFIX + key
    return key


def matlab_safe(obj):
    """Make `obj` writeable by scipy.io.savemat.

    Two fixes are applied recursively:

    - None becomes [], because savemat has no encoding for None and raises
      TypeError on it. Nullable columns and nulls nested inside `params` blobs
      (e.g. the suite2p imaging paramset) otherwise break the whole .mat file.
      MATLAB reads [] as empty.
    - Dict keys that MATLAB cannot use as struct field names are renamed by
      matlab_field_name, because savemat would otherwise discard them along
      with their values.
    """
    if obj is None:
        return []
    if isinstance(obj, dict):
        return {matlab_field_name(k): matlab_safe(v) for k, v in obj.items()}
    if isinstance(obj, list):
        return [matlab_safe(v) for v in obj]
    if isinstance(obj, tuple):
        return tuple(matlab_safe(v) for v in obj)
    return obj
