
function fillUsers(app, key)

if nargin < 2
    key = [];
end

users_subj = fetchDataDJTable(lab.User, key, {'user_id'}, "struct");

app.UserPreparamListDrop.Items = {'general-user', users_subj.user_id};
end