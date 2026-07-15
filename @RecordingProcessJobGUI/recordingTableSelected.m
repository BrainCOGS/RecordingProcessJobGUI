function recordingTableSelected(app, event)
%RECORDINGTABLESELECTED Show the status history of the recording selected in Tab 3
%
%   CellSelectionCallback for app.RecordingTableRT ("Recording Table" tab).
%   Reads the recording_id out of the first column of the clicked row and fetches
%   that recording's whole status history from app.recording_history_table_class
%   (recording.LogStatus), newest entry first, then writes it to
%   app.RecordingHistortyTable. Only the columns named in
%   app.COLUMNS_RECORDING_STATUS_TABLE are fetched, so the struct field order
%   matches the widget's column order (app.COLUMNS_RECORDING_STATUS_NAMES) and the
%   result can be dumped straight in via struct2cell.
%
%   Status colouring: the status_recording_id_new cell of each history row is
%   painted red when the new status equals app.min_rec_status (error) and green
%   when it equals app.max_rec_status (fully processed). Previous styling is
%   cleared first with removeStyle.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - CellSelection event; event.Indices(1) is
%                                      the clicked row of app.RecordingTableRT
%
%   Outputs:
%       None - Updates app.RecordingHistortyTable.Data and its red/green styles
%
%   Dependencies:
%       - recording.LogStatus (via app.recording_history_table_class)
%
%   See also: fillRecordingTable, jobTableSelected, fillJobStatusTable, setStyleCellsTable

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







