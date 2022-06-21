
function createRecordingButton(app, event)

updateBusyLabel(app, false);


if app.DefaultParametersCheckBox.Value
    createRecording(app, event);
else
    app.TabGroup.SelectedTab = app.SelectRecordingParametersTab;
    
    fillUserParams(app);
    fillParams2Select(app);
        
end


end