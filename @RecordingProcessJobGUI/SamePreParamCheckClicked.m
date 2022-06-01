function SamePreParamCheckClicked(app, event)
%SAMEPREPARAMCHECKCLICKED 

if app.SamePreParamListRecordingCheckBox.Value
    app.ListBoxFragmentRecording.Enable = 'on';
else
    app.ListBoxFragmentRecording.Enable = 'off';
end

end

