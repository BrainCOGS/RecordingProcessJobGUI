function fillRecordingSubject(app, key)

if nargin < 2
    key = [];
end

rec_process_table = fetchDataDJTable(app.RecordingProcessTable, key, {'subject_fullname'}, "table");

%Subject filter
if ~isempty(rec_process_table)
    app.SubjectDropDown_2.Items = unique(rec_process_table.subject_fullname);
end

end