function fillRecordingUserRT(app)

rec_process_table = fetchDataDJTable(app.RecordingTable, [], {'user_id'}, "table");
extra_recordings = fetchDataDJTable(app.RecordingTable2, [], {'user_id'}, "table");

if ~isempty(extra_recordings)
    rec_process_table = [rec_process_table; extra_recordings];
end

%User filter
if ~isempty(rec_process_table)
    app.UserDropDownRT.Items = unique(rec_process_table.user_id);
end


end