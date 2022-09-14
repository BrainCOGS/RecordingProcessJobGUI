function fillRecordingTable(app, key)

if nargin < 2
    key = [];
end

app.DataRecordingTable = fetchDataDJTable(app.RecordingTable, key, {'*'}, "table", "ORDER BY recording_id");

%Which cells are going to be red or green colored because of status
rec_errors = find([app.DataRecordingTable.status_recording_id] == app.min_rec_status);
rec_finished = find([app.DataRecordingTable.status_recording_id] == app.max_rec_status);

idx_status_rec_id_column = find(ismember(app.COLUMNS_TABLE_RT,'status_recording_id'),1);
idx_cells_red = [rec_errors repmat(idx_status_rec_id_column,size(rec_errors))];
idx_cells_green = [rec_finished repmat(idx_status_rec_id_column,size(rec_finished))];

removeStyle(app.RecordingTableRT);
if ~isempty(app.DataTable)
    app.RecordingTableRT.Data = table2cell(app.DataRecordingTable(:,app.COLUMNS_TABLE_RT));
    if ~isempty(idx_cells_red)
        app.setStyleCellsTable(app.RecordingTableRT, app.RED_STYLE, idx_cells_red);
    end
    if ~isempty(idx_cells_green)
        app.setStyleCellsTable(app.RecordingTableRT, app.GREEN_STYLE, idx_cells_green);
    end
else
    app.RecordingTableRT.Data = {};
end

end