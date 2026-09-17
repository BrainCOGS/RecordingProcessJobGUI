function test_jsonencodepretty
%TEST_JSONENCODEPRETTY Checks on the field-name decoding in jsonencodepretty
%
%   PythonScripts/matlab_export.py prefixes paramset keys MATLAB cannot use as
%   struct field names with an 'x' so savemat does not drop them. This checks
%   jsonencodepretty undoes that for display, and only for real keys.
%
%   Run from the repo root:
%     matlab -batch "addpath(pwd); addpath([pwd filesep 'tests']); test_jsonencodepretty"

% Strip the cosmetic carriage returns so names can be compared directly.
flat = @(s) strrep(jsonencodepretty(s), sprintf('\r'), '');

% The bug: a key that savemat would have dropped is shown under its real name.
s.x1Preg = false; s.tau = 1.0; s.xcorr = 3; s.x_priv = 7; s.spatial_hp = 50;
out = flat(s);
assert(contains(out, '"1Preg":false'), 'x1Preg was not decoded');
assert(~contains(out, 'x1Preg'),       'prefixed name leaked to the viewer');
assert(contains(out, '"_priv":7'),     'x_priv was not decoded');

% A name that merely starts with x must keep it.
assert(contains(out, '"xcorr":3'),     'xcorr was wrongly stripped');
assert(contains(out, '"tau":1'),       'plain field damaged');
assert(contains(out, '"spatial_hp":50'), 'plain field damaged');

% A string VALUE shaped like a prefixed key must not be rewritten.
v.baseline = 'x1abc'; v.other = 2;
assert(contains(flat(v), '"x1abc"'), 'string value was rewritten');

% Single character after the prefix.
w.x2 = 1;
assert(contains(flat(w), '"2":1'), 'x2 was not decoded');

% Nothing to decode - output must be untouched.
p.tau = 1; p.nplanes = 0;
assert(contains(flat(p), '"tau":1') && contains(flat(p), '"nplanes":0'), ...
    'unprefixed struct damaged');

fprintf('test_jsonencodepretty: all assertions passed\n');
end
