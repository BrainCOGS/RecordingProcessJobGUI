function SamePreParamCheckClicked(app, event)
%SAMEPREPARAMCHECKCLICKED 

if app.SamePreParamListRecordingCheckBox.Value
    app.ListBoxFragmentRecording.Enable = 'off';
    app.RegisterPreparamsFragment.Enable = 'off';
    app.ListBoxFragmentRecordingPreParams.Enable = 'off';
else
    app.ListBoxFragmentRecording.Enable = 'on';
    app.RegisterPreparamsFragment.Enable = 'on';
    app.ListBoxFragmentRecordingPreParams.Enable = 'on';
end

end

