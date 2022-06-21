
function fillParams2Select(app, event)

idx_preprocess = app.PreProcessParamList.recording_modality == app.Configuration.RecordingModality;
idx_process = app.ProcessParams.recording_modality == app.Configuration.RecordingModality;

if ~strcmp(app.UserParamsDropDown.Value,'all')
    idx_preprocess = idx_preprocess & app.PreProcessParamList.user_params == app.UserParamsDropDown.Value;
    idx_process =    idx_process    & app.ProcessParams.user_params  == app.UserParamsDropDown.Value;
end

preprocess_names = app.PreProcessParamList{idx_preprocess, app.preparam_steps_name_field};

params_desc = app.ProcessParams{idx_process, app.params_desc_field};

app.PreprocessingParamsDropDown.Items = unique(preprocess_names);

app.ProcessingParamsDropDown.Items = unique(params_desc);

% If the user has no processing parameters
if isempty(app.ProcessingParamsDropDown.Items)
    app.UserDateParamsLabel2.Text = '';
else
    app.ParamSetSelected(app.ProcessingParamsDropDown);
    
% If the user has no preprocessing parameters
if isempty(app.PreprocessingParamsDropDown.Items)
    app.PreprocessingParamsStepsList.Items = {};
    app.PreParamsDescriptionLabel2.Text = '';
    app.UserDatePreParamsLabel2.Text = '';
else
    app.ParamListSelected(app.PreprocessingParamsDropDown);
end


end