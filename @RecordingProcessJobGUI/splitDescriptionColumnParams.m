
function split_param_table = splitDescriptionColumnParams(app, param_table)

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





