
function fillUserParams(app)

user_preprocessing = app.PreProcessParamList{...
        app.PreProcessParamList.recording_modality == app.Configuration.RecordingModality, 'user_params'};
    
user_proccessing = app.ProcessParams{...
        app.ProcessParams.recording_modality == app.Configuration.RecordingModality, 'user_params'};
    

all_users = sort(unique([user_preprocessing; user_proccessing]));

%Let's put on top all & general-user
idx_gen = all_users == categorical({'general-user'});
all_users(idx_gen) = [];
all_users = categorical([{'all'; 'general-user'}; all_users]);
    
app.UserParamsDropDown.Items = all_users;
app.UserParamsDropDown.Value = all_users(1);

end