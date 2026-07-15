function fillRecordingUser(app)
%FILLRECORDINGUSER Fill the user filter dropdown on the Manage Processing Jobs tab
%
%   Populates app.UserDropDown (Manage Processing Jobs tab, GridLayoutJobs) with the
%   distinct user_id values that own at least one processing job. This is the
%   Manage-Jobs-tab counterpart of fillRecordingUserRT, which fills the Recording
%   Table tab's equivalent filter (app.UserDropDownRT).
%
%   Fetches user_id from both job queries built in startupFcn and concatenates them:
%       app.RecordingProcessTable  - jobs whose recording links to a behavior session
%                                    (recording_process.Processing * recording.Recording
%                                    * recording.RecordingBehaviorSession * subject.Subject
%                                    * lab.User * recording_process.Status)
%       app.RecordingProcessTable2 - jobs with no behavior session, linked through
%                                    recording.RecordingRecordingSession (session_number = -1)
%   No DataJoint restriction is applied (key is passed as []), so the dropdown always
%   lists every user with a job, independent of the current filter. unique() collapses
%   the union to the sorted distinct user list. If both queries return empty the
%   dropdown is left untouched.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The main application object
%
%   Outputs:
%       None - Sets app.UserDropDown.Items
%
%   Dependencies:
%       - fetchDataDJTable
%       - DataJoint: recording_process.Processing, recording.Recording,
%         recording.RecordingBehaviorSession, recording.RecordingRecordingSession,
%         subject.Subject, lab.User, recording_process.Status (via app.RecordingProcessTable
%         / app.RecordingProcessTable2)
%
%   See also: fillRecordingUserRT, fillRecordingSubject, filterTable, FillEverything

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