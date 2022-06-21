function recordingTableSelected(app, event)
%JOBTABLESELECTED Summary of this function goes here
%   Detailed explanation goes here

recording_id = app.UITableRT.Data{event.Indices(1),1};
query.recording_id = recording_id;

columns = [app.COLUMNS_RECORDING_STATUS_TABLE, {'ORDER BY recording_status_timestamp desc'}];

rec_status_history = fetch(app.recording_history_table_class() & query,columns{:});

if ~isempty(rec_status_history)
    data = struct2cell(rec_status_history);
    app.RecordingHistortyTable.Data = data';
end

end



