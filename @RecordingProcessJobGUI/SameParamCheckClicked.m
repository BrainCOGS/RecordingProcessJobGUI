function SameParamCheckClicked(app, event)
%SAMEPREPARAMCHECKCLICKED 

if app.SameParamsRecordingCheckBox.Value
    app.ListBoxFragmentRecording2.Enable = 'on';
else
    app.ListBoxFragmentRecording2.Enable = 'off';
end

end

