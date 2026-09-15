function fillRecordingSubject(app, key)
%FILLRECORDINGSUBJECT Fill the subject filter dropdown on the Manage Processing Jobs tab
%
%   Populates app.SubjectDropDown_2 (Manage Processing Jobs tab, GridLayoutJobs) with the
%   distinct subject_fullname values that have at least one processing job matching key.
%   This is the Manage-Jobs-tab counterpart of fillRecordingSubjectRT, which fills the
%   Recording Table tab's equivalent filter (app.SubjectDropDownRT).
%
%   Fetches subject_fullname from both job queries built in startupFcn and concatenates
%   them:
%       app.RecordingProcessTable  - jobs whose recording links to a behavior session
%       app.RecordingProcessTable2 - jobs with no behavior session, linked through
%                                    recording.RecordingRecordingSession (session_number = -1)
%   Unlike fillRecordingUser, key IS forwarded to fetchDataDJTable, so the subject list
%   narrows to the currently selected job filter. filterTable calls it with
%   app.FilterRecordingJob, a struct whose only field at that point is user_id (set from
%   the app.UserDropDown selection), or an empty struct() to clear the filter. Callers
%   that want the unrestricted list (CreateNewJob, RerunJob, FillEverything) omit key.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The main application object
%       key (struct | char | [])     - Optional DataJoint restriction on the job queries.
%                                      Typically app.FilterRecordingJob with field
%                                      user_id. Defaults to [] (no restriction).
%
%   Outputs:
%       None - Sets app.SubjectDropDown_2.Items
%
%   Dependencies:
%       - fetchDataDJTable
%       - DataJoint: recording_process.Processing, recording.Recording,
%         recording.RecordingBehaviorSession, recording.RecordingRecordingSession,
%         subject.Subject, lab.User, recording_process.Status (via app.RecordingProcessTable
%         / app.RecordingProcessTable2)
%
%   See also: fillRecordingSubjectRT, fillRecordingUser, filterTable, fillJobTable

if nargin < 2
    key = [];
end

rec_process_table = fetchDataDJTable(app.RecordingProcessTable, key, {'subject_fullname'}, "table");
extra_jobs = fetchDataDJTable(app.RecordingProcessTable2, key, {'subject_fullname'}, "table");

if ~isempty(extra_jobs)
    if isempty(rec_process_table)
        rec_process_table = extra_jobs;
    else
        rec_process_table = [rec_process_table; extra_jobs];
    end
end

%Subject filter
if ~isempty(rec_process_table)
    app.SubjectDropDown_2.Items = unique(rec_process_table.subject_fullname);
end

end