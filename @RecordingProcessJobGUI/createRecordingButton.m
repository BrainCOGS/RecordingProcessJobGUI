
function createRecordingButton(app, event)

event.Source.Enable = 'off';
updateBusyLabel(app, false);


if app.DefaultParametersCheckBox.Value
    createRecording(app, event);
else
    app.TabGroup.SelectedTab = app.SelectRecordingParametersTab;
    app.PreprocessingParamsDropDown.Items = app.PreProcessParamList.steps_description;
    
    
    
end


end