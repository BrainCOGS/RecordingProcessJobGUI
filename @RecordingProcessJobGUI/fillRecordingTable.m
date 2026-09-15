function fillRecordingTable(app, key)
%FILLRECORDINGTABLE Populate the Recording Table (Tab 3) from recording.Recording
%
%   Fetches every registered recording matching the restriction KEY and writes
%   it to app.RecordingTableRT, the main table of the "Recording Table" tab.
%   Two joins are queried and concatenated, because a recording may be linked to
%   its session in one of two ways (see startupFcn): app.RecordingTable covers
%   recordings tied to a behavior session (recording.RecordingBehaviorSession),
%   app.RecordingTable2 covers recordings with no behavior, tied instead through
%   recording.RecordingRecordingSession with session_number forced to -1. The
%   full fetched result is cached in app.DataRecordingTable (all columns), while
%   only the columns listed in app.COLUMNS_TABLE_RT are shown in the widget, in
%   that order, under the headers app.COLUMNS_NAMES_RT.
%
%   Status colouring: the status_recording_id cell of each row is painted red
%   when the status equals app.min_rec_status (the error status) and green when
%   it equals app.max_rec_status (fully processed). Both bounds come from
%   recording.Status at startup. Any previous styling is cleared first with
%   removeStyle.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       key (struct)                 - Optional DataJoint restriction applied to
%                                      both recording joins (e.g. .user_id,
%                                      .subject_fullname, .session_date, as built
%                                      by filterTable into app.FilterRecordingRT).
%                                      Defaults to [] = no restriction.
%
%   Outputs:
%       None - Sets app.DataRecordingTable and app.RecordingTableRT.Data, and
%              re-applies the red/green cell styles
%
%   Dependencies:
%       - fetchDataDJTable
%       - recording.Recording, recording.Status,
%         recording.RecordingBehaviorSession, recording.RecordingRecordingSession
%
%   See also: fillJobTable, recordingTableSelected, filterTable, setStyleCellsTable

if nargin < 2
    key = [];
end

app.DataRecordingTable = fetchDataDJTable(app.RecordingTable, key, {'*'}, "table", "ORDER BY recording_id");
extra_recordings = fetchDataDJTable(app.RecordingTable2, key, {'*'}, "table", "ORDER BY recording_id");

if ~isempty(extra_recordings)
    app.DataRecordingTable = [app.DataRecordingTable; extra_recordings];
end

%Which cells are going to be red or green colored because of status
rec_errors = find([app.DataRecordingTable.status_recording_id] == app.min_rec_status);
rec_finished = find([app.DataRecordingTable.status_recording_id] == app.max_rec_status);

idx_status_rec_id_column = find(ismember(app.COLUMNS_TABLE_RT,'status_recording_id'),1);
idx_cells_red = [rec_errors repmat(idx_status_rec_id_column,size(rec_errors))];
idx_cells_green = [rec_finished repmat(idx_status_rec_id_column,size(rec_finished))];

removeStyle(app.RecordingTableRT);
if ~isempty(app.DataRecordingTable)
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