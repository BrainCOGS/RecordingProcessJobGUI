function fillTable(app, key)

if nargin < 2
    key = [];
end

app.DataTable = fetchDataDJTable(app.RecordingProcessTable, key, {'*'}, "table", "ORDER BY job_id");


if ~isempty(app.DataTable)
    app.UITable.Data = table2cell(app.DataTable(:, app.COLUMNS_TABLE));
else
    app.UITable.Data = {};
end

end