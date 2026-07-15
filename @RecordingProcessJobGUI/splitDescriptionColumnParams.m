
function split_param_table = splitDescriptionColumnParams(app, param_table)
%SPLITDESCRIPTIONCOLUMNPARAMS Split a params description column into user, date and description
%
%   Undoes the naming convention that writeParametersDB and RegisterPreParamList
%   apply when they register params: descriptions are stored in the DB as
%   '<user>_<yyyy-mm-dd>_<description>' so that authorship and date travel with the
%   paramset. This reshapes such a table so those three parts become their own
%   columns, which is what makes the 'user_params' and 'date_params' columns in
%   COLUMNS_DEF_PARAMS_TABLE / COLUMNS_DEF_PREPARAMS_TABLE displayable.
%
%   Every column whose name contains '_desc' is processed: its text is split on
%   '_', the description column is overwritten in place with just the description
%   part, and 'user_params' / 'date_params' columns are added to the table.
%   Called by fillParams on app.PreProcessParamList and app.ProcessParams, before
%   they are converted to categorical.
%
%   Rows that do not split into exactly three parts are handled by the local
%   get_sub_cell helper, which then yields '' for user and date and falls back to
%   the last fragment for the description - so a description that does not follow
%   the convention degrades instead of erroring.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object (unused)
%       param_table (table)          - Params table with one or more '_desc' columns
%
%   Outputs:
%       split_param_table (table) - Copy of param_table with each '_desc' column
%                                   reduced to the description text, plus added
%                                   'user_params' and 'date_params' columns
%
%   See also: fillParams, writeParametersDB, RegisterPreParamList, loadParamsFile

split_param_table = param_table;
columns = param_table.Properties.VariableNames;

idx_desc_table = find(contains(columns, '_desc'));

for i = 1:length(idx_desc_table)

    description_column = string(param_table{:, idx_desc_table(i)});

    split_column = arrayfun(@(x) strsplit(x, "_"), description_column, 'Un', false);

    user_column = cellfun(@(x) get_sub_cell(x, 1, 3), split_column, 'Un', false);
    date_column = cellfun(@(x) get_sub_cell(x, 2, 3), split_column, 'Un', false);
    desc_column = cellfun(@(x) get_sub_cell(x, 3, 3), split_column, 'Un', false);

    split_param_table{:, idx_desc_table(i)} = desc_column;
    split_param_table.user_params = user_column;
    split_param_table.date_params = date_column;
    
end

end


function value = get_sub_cell(this_cell, idx, desired_length)

if length(this_cell) == desired_length
    value = this_cell{idx};
else
    if idx == desired_length
        value = this_cell{end};
    else
        value = '';
    end
    
end


end





