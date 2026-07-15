
function fillRecordingDirectories(app)
%FILLRECORDINGDIRECTORIES Scan the recording root directory and fill the subject dropdowns
%
%   Superseded and currently unreachable: nothing in the class calls this method.
%   The live scan of app.Configuration.RecordingRootDirectory that actually builds
%   app.RecordingDirectoryTable and app.RecordingDirectoryDropDown.Items now happens
%   in postConfigurationActions. Kept only because it is still listed in the class
%   method list and in Recording_Automation_GUI.prj -- read postConfigurationActions
%   instead, and see the report notes below before reviving this.
%
%   As written, when the root directory exists it dirwalks it with @visitor2 for
%   '^.*\.mat$' files (discarding both outputs), then fetches every
%   subject_fullname from lab.User * subject.Subject and loads the sorted list,
%   prefixed with 'All', into app.RecordingSubjectDropDown and
%   app.RecordingSubjectDropDown_2 -- i.e. the body is a copy of fillSubjects and
%   never touches a recording directory at all. The `key` restriction it branches on
%   is never a parameter of this function, so the unrestricted fetch always runs.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%
%   Outputs:
%       None - Sets the Items/Value of app.RecordingSubjectDropDown and
%              app.RecordingSubjectDropDown_2
%
%   Dependencies:
%       - DataJoint tables: lab.User, subject.Subject
%       - dirwalk, visitor2
%
%   See also: postConfigurationActions, fillSubjects, findLikelyBehaviorSessionFromRecDir

if isfolder(app.Configuration.RecordingRootDirectory)
    
[fileNmes, dirs] = dirwalk(app.Configuration.RecordingRootDirectory, @visitor2, '^.*\.mat$');

if nargin < 2
    key = '';
end

if isempty(key)
    users_subj = fetch(lab.User * proj(subject.Subject, 'user_id'),  'user_id');
else
    users_subj = fetch(lab.User * proj(subject.Subject, 'user_id') & key, 'user_id');
end

subjects = sort({users_subj.subject_fullname});
app.RecordingSubjectDropDown_2.Items = [{'All'} subjects];
app.RecordingSubjectDropDown_2.Value = 'All';
app.RecordingSubjectDropDown.Items = [{'All'} subjects];
app.RecordingSubjectDropDown.Value = 'All';

end