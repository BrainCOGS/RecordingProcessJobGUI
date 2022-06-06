
function createRecordingButton(app, event)

event.Source.Enable = 'off';
updateBusyLabel(app, false);


if app.DefaultParametersCheckBox.Value
    createRecording(app, event);
else
    app.TabGroup.SelectedTab = app.SelectRecordingParametersTab;
    
    preprocess_modality = app.PreProcessParamList{...
        app.PreProcessParamList.recording_modality == app.Configuration.RecordingModality, 'steps_description'};
    
    params_modality = app.ProcessParams{...
        app.ProcessParams.recording_modality == app.Configuration.RecordingModality, 'paramset_desc'};
    
    
    app.PreprocessingParamsDropDown.Items = unique(preprocess_modality);
    
    app.ProcessingParamsDropDown.Items = unique(params_modality);
    
    app.ParamListSelected(app.PreprocessingParamsDropDown)
    
    
    
end


end