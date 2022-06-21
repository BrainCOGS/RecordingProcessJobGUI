function fillRecordingUser(app)

rec_process_table = fetchDataDJTable(app.RecordingProcessTable, [], {'user_id'}, "table");

%User filter
if ~isempty(rec_process_table)
    app.UserDropDown.Items   = unique(rec_process_table.user_id);
end

end