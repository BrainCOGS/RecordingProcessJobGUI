function t = rename_table_var(t, old_name, new_name)
%RENAME_TABLE_VAR Rename one table variable, on MATLAB releases before renamevars
%
%   Drop-in for renamevars(t, old_name, new_name) with a single name. renamevars
%   only exists from R2020a, and some rigs still run R2019b, where calling it
%   crashed startup whenever uv was missing and fillParams fell back to
%   getParamsFromMatlab.
%
%   Inputs:
%       t        (table)       - Table to rename a variable of
%       old_name (char/string) - Existing variable name
%       new_name (char/string) - Name to give it
%
%   Outputs:
%       t (table) - The same table with the variable renamed. Errors, as
%                   renamevars does, if old_name is not a variable of t
%
%   See also: getParamsFromMatlab, getMethods

idx = strcmp(t.Properties.VariableNames, char(old_name));
if ~any(idx)
    error('rename_table_var:unknownVariable', ...
        'Table has no variable named ''%s''.', char(old_name));
end
t.Properties.VariableNames{idx} = char(new_name);

end
