function out_table = convertTable2Categorical(in_table)
%CONVERTTABLE2CATEGORICAL convert all string variables of table to
%categorical

out_table = in_table;
vars = in_table.Properties.VariableNames;

for i=1:length(vars)
    var = vars{i};
    if iscell(in_table.(var)) && ischar(in_table.(var){1})
        out_table.(var) = categorical(in_table.(var));
    end
    
end

