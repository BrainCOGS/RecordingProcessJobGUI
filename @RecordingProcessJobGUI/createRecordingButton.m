
function createRecordingButton(app, event)

event.Source.Enable = 'off';
updateBusyLabel(app, false);


if app.DefaultParametersCheckBox.Value
    createRecording(app, event);
else
    app.TabGroup.SelectedTab = app.SelectRecordingParametersTab;
    app.PreprocessingParamsDropDown.Items = unique(app.PreProcessParamList.steps_description);
    
    app.ProcessingParamsDropDown.Items = unique(app.ProcessParams.paramset_desc);
    
    app.ParamListSelected(app.PreprocessingParamsDropDown)
    
    
    
end


end