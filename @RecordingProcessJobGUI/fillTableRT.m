function fillTableRT(app, key)

if nargin < 2
    key = [];
end

app.DataRecordingTable = fetchDataDJTable(app.RecordingTable, key, {'*'}, "table", "ORDER BY recording_id");

if ~isempty(app.DataTable)
    app.UITableRT.Data = table2cell(app.DataRecordingTable(:,app.COLUMNS_TABLE_RT));
else
    app.UITableRT.Data = {};
end

end