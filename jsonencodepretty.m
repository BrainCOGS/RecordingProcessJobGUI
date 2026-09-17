function json_pretty = jsonencodepretty(text)
%JSONENCODEPRETTY Encode a struct as JSON broken across lines for display
%
%   jsonencode returns everything on one line, which is unreadable in the
%   params text areas. This re-breaks that single line: it inserts a carriage
%   return before each field name after the first (found by searching for
%   `"<fieldname>":`), and puts the braces of an object array on their own
%   lines by expanding '[{' and '}]'. It is cosmetic only - no indentation is
%   added and the result is still valid JSON.
%
%   Used to fill app.ParamsTextArea (ParamSetSelected, PreparamStepSelected)
%   and app.CreateParamsTextArea (CreatePreparamStepSelected,
%   UploadParamJsonFile) with the params blob of the selected paramset.
%
%   Inputs:
%       text (struct/cell) - Struct to encode. A cell is unwrapped first and
%                            only its first element is used, since the params
%                            blob comes out of a table cell
%
%   Outputs:
%       json_pretty (char) - JSON text with a carriage return before every
%                            field after the first
%
%   See also: loadJSONfile, saveJSONfile, ParamSetSelected,
%   CreatePreparamStepSelected

if iscell(text)
    text = text{1};
end

json_pretty = jsonencode(text);

all_fields =  fieldnames(text);

for i=2:length(all_fields)
       idx_field = strfind(json_pretty, all_fields{i}+""":");
       json_pretty = [json_pretty(1:idx_field-1), sprintf('\r'), json_pretty(idx_field:end)];
end

json_pretty = strrep(json_pretty, '[{', sprintf('[\r{\r'));
json_pretty = strrep(json_pretty, '}]', sprintf('\r}\r]'));

% Undo the 'x' that PythonScripts/matlab_export.py prepends to paramset keys
% MATLAB cannot use as struct field names, so the viewer shows the key as it is
% stored in the database ("x1Preg" -> "1Preg"). The match is deliberately
% narrow: the 'x' must open a string, be followed by a digit or underscore, and
% that string must end in '":' - i.e. be a key, not a value. So xcorr keeps its
% x, and the string value "x1abc" is left alone. The optional \r allows for the
% line break the loop above inserts between the quote and the field name, so
% this must run after that loop.
json_pretty = regexprep(json_pretty, ['(?<=")(' sprintf('\r') '?)x(?=[0-9_][^"]*":)'], '$1');