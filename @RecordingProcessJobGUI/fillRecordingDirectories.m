
function fillRecordingDirectories(app)

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