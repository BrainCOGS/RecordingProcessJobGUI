function recordingTableSelected(app, event)
%JOBTABLESELECTED Summary of this function goes here
%   Detailed explanation goes here

recording_id = app.RecordingTableRT.Data{event.Indices(1),1};
query.recording_id = recording_id;

columns = [app.COLUMNS_RECORDING_STATUS_TABLE, {'ORDER BY recording_status_timestamp desc'}];
rec_status_history = fetch(app.recording_history_table_class() & query,columns{:});

%Which cells are going to be red or green colored because of status
rec_errors = find([rec_status_history.status_recording_id_new] == app.min_rec_status);
rec_errors = rec_errors(:);
rec_finished = find([rec_status_history.status_recording_id_new] == app.max_rec_status);
rec_finished = rec_finished(:);

idx_status_rec_id_column = find(ismember(app.COLUMNS_RECORDING_STATUS_TABLE,'status_recording_id_new'),1);
idx_cells_red = [rec_errors repmat(idx_status_rec_id_column,size(rec_errors))];
idx_cells_green = [rec_finished repmat(idx_status_rec_id_column,size(rec_finished))];


removeStyle(app.RecordingHistortyTable);
if ~isempty(rec_status_history)
    data = struct2cell(rec_status_history);
    app.RecordingHistortyTable.Data = data';
    app.setStyleCellsTable(app.RecordingHistortyTable, app.RED_STYLE, idx_cells_red);
    app.setStyleCellsTable(app.RecordingHistortyTable, app.GREEN_STYLE, idx_cells_green);
end

end







