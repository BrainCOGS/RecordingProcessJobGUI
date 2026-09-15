function out_table = convertTable2Categorical(in_table)
%CONVERTTABLE2CATEGORICAL Convert the text variables of a table to categorical
%
%   Walks every variable of a MATLAB table and converts the ones holding text
%   into categorical. A variable is treated as text when it is a cell array
%   whose first element is a char row vector - which is exactly what a
%   DataJoint fetch of a string/varchar/enum column produces after
%   struct2table. Numeric, logical and blob variables are copied through
%   untouched.
%
%   Categorical variables are what the app's filter dropdowns and uitable
%   sorting expect, so tables coming back from fetchDataDJTable are passed
%   through here before being stored on the app (app.RecordingModalityTable in
%   startupFcn; app.PreProcessParams, app.ProcessParams, app.PreProcessParamList,
%   app.MehodsTable and app.PreMethodsTable in fillParams).
%
%   Inputs:
%       in_table (table) - Table to convert, typically straight from
%                          fetchDataDJTable or fetch_table_except
%
%   Outputs:
%       out_table (table) - Copy of in_table with every cellstr variable
%                           replaced by a categorical of the same values.
%                           Variable names and row order are preserved
%
%   See also: fetchDataDJTable, fetch_table_except, fillParams, startupFcn

out_table = in_table;
vars = in_table.Properties.VariableNames;

for i=1:length(vars)
    var = vars{i};
    if iscell(in_table.(var)) && ischar(in_table.(var){1})
        out_table.(var) = categorical(in_table.(var));
    end
    
end

