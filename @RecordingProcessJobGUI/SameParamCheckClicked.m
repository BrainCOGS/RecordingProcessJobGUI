function SameParamCheckClicked(app, event)
%SAMEPREPARAMCHECKCLICKED 

if app.SameParamsRecordingCheckBox.Value
    app.ListBoxFragmentRecording2.Enable = 'off';
    app.RegisterParamsFragment.Enable = 'off';
    app.ListBoxFragmentRecording2Params.Enable = 'off';
else
    app.ListBoxFragmentRecording2.Enable = 'on';
    app.RegisterParamsFragment.Enable = 'on';
    app.ListBoxFragmentRecording2Params.Enable = 'on';
end

end

