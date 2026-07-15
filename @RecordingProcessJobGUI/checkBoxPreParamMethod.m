
function checkBoxPreParamMethod(app, event)
%CHECKBOXPREPARAMMETHOD Toggle between picking an existing pre-processing method and typing a new one
%
%   ValueChanged callback for app.NewPreParamMethodCheckBox ("Define new
%   preproc.-param method ?") on the Create Parameters tab. Only one of the two
%   ways of naming a pre-processing method is ever enabled: when the box is
%   checked the existing-method dropdown (app.CreatePreParamSetMethodsDrop, whose
%   Items fillPreParamsSets fills from the methods already in the DB for the
%   selected modality) is greyed out and the free-text field
%   app.NewPreParamMethodEdit is enabled; when it is unchecked the reverse. Each
%   control is enabled together with its label. writeParametersDB reads the same
%   checkbox to decide which of the two values to pass as the method, and whether
%   it must first insert that new method into the per-modality pre-processing
%   method table (PreClusterMethod for ephys, PreprocessMethod for imaging).
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - Checkbox ValueChanged event (unused; the
%                                      state is read from the checkbox itself)
%
%   Outputs:
%       None - Flips the Enable state of app.CreatePreParamSetMethodsDropLabel,
%              app.CreatePreParamSetMethodsDrop, app.NewPreParamMethodLabel and
%              app.NewPreParamMethodEdit
%
%   See also: checkBoxParamMethod, writeParametersDB, fillPreParamsSets

if app.NewPreParamMethodCheckBox.Value
    app.CreatePreParamSetMethodsDropLabel.Enable = 'off';
    app.CreatePreParamSetMethodsDrop.Enable = 'off';
    app.NewPreParamMethodLabel.Enable = 'on';
    app.NewPreParamMethodEdit.Enable = 'on';
else
    app.CreatePreParamSetMethodsDropLabel.Enable = 'on';
    app.CreatePreParamSetMethodsDrop.Enable = 'on';
    app.NewPreParamMethodLabel.Enable = 'off';
    app.NewPreParamMethodEdit.Enable = 'off';
end
    
end