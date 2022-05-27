function fillRecordingSubjectRT(app, key)

if nargin < 2
    key = [];
end

rec_process_table = fetchDataDJTable(app.RecordingTable, key, {'subject_fullname'}, "table");

%Subject filter
if ~isempty(rec_process_table)
    app.SubjectDropDownRT.Items = unique(rec_process_table.subject_fullname);
end

end