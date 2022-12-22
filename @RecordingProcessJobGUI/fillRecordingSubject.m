function fillRecordingSubject(app, key)

if nargin < 2
    key = [];
end

rec_process_table = fetchDataDJTable(app.RecordingProcessTable, key, {'subject_fullname'}, "table");
extra_jobs = fetchDataDJTable(app.RecordingProcessTable2, key, {'subject_fullname'}, "table");

if ~isempty(extra_jobs)
    rec_process_table = [rec_process_table; extra_jobs];
end

%Subject filter
if ~isempty(rec_process_table)
    app.SubjectDropDown_2.Items = unique(rec_process_table.subject_fullname);
end

end