function fillRecordingUserRT(app)
%FILLRECORDINGUSERRT Fill the user filter dropdown on the Recording Table tab
%
%   RT = Recording Table tab. Populates app.UserDropDownRT (Recording Table tab,
%   GridLayoutRT) with the distinct user_id values that own at least one registered
%   recording. This is the Recording-Table-tab counterpart of fillRecordingUser, which
%   fills the Manage Processing Jobs tab's equivalent filter (app.UserDropDown).
%   The difference is the source query: this function reads the *recording* queries
%   (recording.Recording / recording.Status), fillRecordingUser reads the *job* queries
%   (recording_process.Processing / recording_process.Status).
%
%   Fetches user_id from both recording queries built in startupFcn and concatenates them:
%       app.RecordingTable  - recordings linked to a behavior session
%                             (recording.Recording * recording.RecordingBehaviorSession
%                             * subject.Subject * lab.User * recording.Status)
%       app.RecordingTable2 - recordings with no behavior session, linked through
%                             recording.RecordingRecordingSession (session_number = -1)
%   No DataJoint restriction is applied (key is passed as []), so the dropdown always
%   lists every user with a recording, independent of the current filter. If both
%   queries return empty the dropdown is left untouched.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The main application object
%
%   Outputs:
%       None - Sets app.UserDropDownRT.Items
%
%   Dependencies:
%       - fetchDataDJTable
%       - DataJoint: recording.Recording, recording.RecordingBehaviorSession,
%         recording.RecordingRecordingSession, subject.Subject, lab.User,
%         recording.Status (via app.RecordingTable / app.RecordingTable2)
%
%   See also: fillRecordingUser, fillRecordingSubjectRT, fillRecordingTable, filterTable

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