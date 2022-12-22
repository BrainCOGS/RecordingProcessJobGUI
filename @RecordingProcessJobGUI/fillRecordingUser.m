function fillRecordingUser(app)

rec_process_table = fetchDataDJTable(app.RecordingProcessTable, [], {'user_id'}, "table");
extra_jobs = fetchDataDJTable(app.RecordingProcessTable2, [], {'user_id'}, "table");

if ~isempty(extra_jobs)
    rec_process_table = [rec_process_table; extra_jobs];
end

%User filter
if ~isempty(rec_process_table)
    app.UserDropDown.Items   = unique(rec_process_table.user_id);
end

end