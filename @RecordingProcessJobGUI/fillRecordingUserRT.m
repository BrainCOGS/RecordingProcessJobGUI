function fillRecordingUserRT(app)

rec_process_table = fetchDataDJTable(app.RecordingTable, [], {'user_id'}, "table");

%User filter
if ~isempty(rec_process_table)
    app.UserDropDownRT.Items = unique(rec_process_table.user_id);
end


end