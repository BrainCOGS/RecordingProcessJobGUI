function fillRecordingSubjectRT(app, key)

if nargin < 2
    key = [];
end

rec_process_table = fetchDataDJTable(app.RecordingTable, key, {'subject_fullname'}, "table");
extra_recordings = fetchDataDJTable(app.RecordingTable2, key, {'subject_fullname'}, "table");

if ~isempty(extra_recordings)
    rec_process_table = [rec_process_table; extra_recordings];
end
    
%Subject filter
if ~isempty(rec_process_table)
    app.SubjectDropDownRT.Items = unique(rec_process_table.subject_fullname);
end

end