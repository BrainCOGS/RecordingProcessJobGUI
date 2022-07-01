
function createRecordingButton(app, event)

updateBusyLabel(app, false);


if app.DefaultParametersCheckBox.Value
    createRecording(app, event);
else
    %Set everything to create a recording on param selection tab
    
    app.TabGroup.SelectedTab = app.SelectRecordingParametersTab;
    app.CreateProcessingJobButton2.Enable = 'on';
    app.CreateProcessingJobButton2.ButtonPushedFcn = createCallbackFcn(app, @checkParamSelection, true);
    app.CreateProcessingJobButton2.Text = 'Register Recording';

    app.SameParamsRecordingCheckBox.Enable = 'on';
    app.SamePreParamListRecordingCheckBox.Enable = 'on';

    app.CreateRecordingOrJob    = true;

    fillUserParams(app);
    fillParams2Select(app);
        
end


end