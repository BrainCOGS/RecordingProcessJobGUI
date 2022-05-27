
function fillSubjects(app, key)

if nargin < 2
    key = [];
end

users_subj = fetchDataDJTable(lab.User * proj(subject.Subject, 'user_id'), key, {'user_id'}, "struct");

subjects = sort({users_subj.subject_fullname});
app.RecordingSubjectDropDown_2.Items = subjects;
app.RecordingSubjectDropDown.Items = subjects;

end