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