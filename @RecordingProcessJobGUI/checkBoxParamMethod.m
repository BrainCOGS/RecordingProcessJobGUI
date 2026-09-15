
function checkBoxParamMethod(app, event)
%CHECKBOXPARAMMETHOD Toggle between picking an existing processing method and typing a new one
%
%   ValueChanged callback for app.NewParamMethodCheckBox ("Define new proc. param
%   method ?") on the Create Parameters tab. The processing-side twin of
%   checkBoxPreParamMethod: only one of the two ways of naming a processing method
%   is ever enabled. When the box is checked the existing-method dropdown
%   (app.CreateParamSetMethodsDrop, whose Items fillPreParamsSets fills from the
%   processing methods already in the DB for the selected modality) is greyed out
%   and the free-text field app.NewParamMethodEdit is enabled; when it is
%   unchecked the reverse. Each control is enabled together with its label.
%   writeParametersDB reads the same checkbox to decide which of the two values to
%   pass as the method, and whether it must first insert that new method into the
%   per-modality processing method table (ClusteringMethod for ephys,
%   ProcessingMethod for imaging).
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - Checkbox ValueChanged event (unused; the
%                                      state is read from the checkbox itself)
%
%   Outputs:
%       None - Flips the Enable state of app.CreateParamSetMethodsDropLabel,
%              app.CreateParamSetMethodsDrop, app.NewParamMethodLabel and
%              app.NewParamMethodEdit
%
%   See also: checkBoxPreParamMethod, writeParametersDB, fillPreParamsSets

if app.NewParamMethodCheckBox.Value
    app.CreateParamSetMethodsDropLabel.Enable = 'off';
    app.CreateParamSetMethodsDrop.Enable = 'off';
    app.NewParamMethodLabel.Enable = 'on';
    app.NewParamMethodEdit.Enable = 'on';
else
    app.CreateParamSetMethodsDropLabel.Enable = 'on';
    app.CreateParamSetMethodsDrop.Enable = 'on';
    app.NewParamMethodLabel.Enable = 'off';
    app.NewParamMethodEdit.Enable = 'off';
end
    
end