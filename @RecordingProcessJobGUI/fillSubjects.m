
function fillSubjects(app, key)
%FILLSUBJECTS Fill the subject dropdown used to register a recording
%
%   Populates app.RecordingSubjectDropDown (Add Recording tab, GridLayout2) with every
%   subject_fullname known to the database, alphabetically sorted. This is the dropdown
%   used when registering a recording that has no behavior session to pick its subject
%   from; it is not a table filter (contrast fillRecordingSubject /
%   fillRecordingSubjectRT, which narrow existing rows).
%
%   The query is lab.User * proj(subject.Subject, 'user_id'): projecting subject.Subject
%   down to its primary key (subject_fullname) plus user_id and joining it against
%   lab.User keeps only subjects whose owning user_id is a valid lab.User. Fetched as a
%   struct array, so subject_fullname arrives via the primary key even though only
%   'user_id' is named in the fetch field list.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The main application object
%       key (struct | char | [])     - Optional DataJoint restriction on the joined
%                                      lab.User * subject.Subject query, e.g. a struct
%                                      with field user_id to list only one user's
%                                      subjects. Defaults to [] (all subjects).
%
%   Outputs:
%       None - Sets app.RecordingSubjectDropDown.Items
%
%   Dependencies:
%       - fetchDataDJTable
%       - DataJoint: lab.User, subject.Subject
%
%   See also: fillSessions, fillUsers, checkBoxSessionRecording, fillRecordingSubject

if nargin < 2
    key = [];
end

users_subj = fetchDataDJTable(lab.User * proj(subject.Subject, 'user_id'), key, {'user_id'}, "struct");

subjects = sort({users_subj.subject_fullname});
app.RecordingSubjectDropDown.Items = subjects;

end