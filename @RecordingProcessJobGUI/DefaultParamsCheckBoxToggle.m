function DefaultParamsCheckBoxToggle(app, event)
%DEFAULTPARAMSCHECKBOXTOGGLE Relabel the Add Recording button for the params path
%
%   ValueChanged callback for app.DefaultParametersCheckBox. Purely cosmetic: it
%   tells the user what the main button is about to do, since the same button either
%   registers the recording outright or moves on to the Select Parameters tab (see
%   createRecordingButton, which is what actually branches on the checkbox).
%
%   Checked   -> 'Register Recording'    on app.GreenBColor  (recording is inserted
%                                        now, using the modality defaults).
%   Unchecked -> 'Select parameters >>>' on app.YellowBColor (params must be picked
%                                        first).
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - CheckBox ValueChanged event (unused)
%
%   Outputs:
%       None - Updates app.CreateProcessingJobButton Text and BackgroundColor
%
%   See also: createRecordingButton, createRecording, createDefaultParamsRecord

if app.DefaultParametersCheckBox.Value
    app.CreateProcessingJobButton.Text = 'Register Recording';
    app.CreateProcessingJobButton.BackgroundColor = app.GreenBColor;
else
    app.CreateProcessingJobButton.Text = 'Select parameters >>>';   
    app.CreateProcessingJobButton.BackgroundColor = app.YellowBColor;
end

end

