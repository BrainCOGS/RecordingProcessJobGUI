function SameParamCheckClicked(app, event)
%SAMEPREPARAMCHECKCLICKED 

if app.SameParamsRecordingCheckBox.Value
    app.ListBoxFragmentRecording2.Enable = 'off';
    app.RegisterParamsFragment.Enable = 'off';
else
    app.ListBoxFragmentRecording2.Enable = 'on';
    app.RegisterParamsFragment.Enable = 'on';
end

end

