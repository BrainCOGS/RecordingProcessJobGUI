function fillRecordingSubjectRT(app, key)
%FILLRECORDINGSUBJECTRT Fill the subject filter dropdown on the Recording Table tab
%
%   RT = Recording Table tab. Populates app.SubjectDropDownRT (Recording Table tab,
%   GridLayoutRT) with the distinct subject_fullname values that have at least one
%   registered recording matching key. This is the Recording-Table-tab counterpart of
%   fillRecordingSubject, which fills the Manage Processing Jobs tab's equivalent filter
%   (app.SubjectDropDown_2). The difference is the source query: this function reads the
%   *recording* queries (recording.Recording / recording.Status), fillRecordingSubject
%   reads the *job* queries (recording_process.Processing / recording_process.Status).
%
%   Fetches subject_fullname from both recording queries built in startupFcn and
%   concatenates them:
%       app.RecordingTable  - recordings linked to a behavior session
%       app.RecordingTable2 - recordings with no behavior session, linked through
%                             recording.RecordingRecordingSession (session_number = -1)
%   key is forwarded to fetchDataDJTable, so the subject list narrows to the current
%   Recording Table filter. filterTable calls it with app.FilterRecordingRT, a struct
%   whose only field at that point is user_id (set from the app.UserDropDownRT
%   selection). createRecording and FillEverything omit key to get the full list.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The main application object
%       key (struct | char | [])     - Optional DataJoint restriction on the recording
%                                      queries. Typically app.FilterRecordingRT with
%                                      field user_id. Defaults to [] (no restriction).
%
%   Outputs:
%       None - Sets app.SubjectDropDownRT.Items
%
%   Dependencies:
%       - fetchDataDJTable
%       - DataJoint: recording.Recording, recording.RecordingBehaviorSession,
%         recording.RecordingRecordingSession, subject.Subject, lab.User,
%         recording.Status (via app.RecordingTable / app.RecordingTable2)
%
%   See also: fillRecordingSubject, fillRecordingUserRT, filterTable, fillRecordingTable

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