
function fillUserParams(app, modality)

if nargin < 2
    modality = app.Configuration.RecordingModality;
end

user_preprocessing = app.PreProcessParamList{...
        app.PreProcessParamList.recording_modality == modality, 'user_params'};
    
user_proccessing = app.ProcessParams{...
        app.ProcessParams.recording_modality == modality, 'user_params'};
    

all_users = sort(unique([user_preprocessing; user_proccessing]));

%Let's put on top all & general-user
idx_gen = all_users == categorical({'general-user'});
all_users(idx_gen) = [];
all_users = categorical([{'all'; 'general-user'}; all_users]);
    
app.UserParamsDropDown.Items = all_users;
app.UserParamsDropDown.Value = cellstr(all_users(1));

end