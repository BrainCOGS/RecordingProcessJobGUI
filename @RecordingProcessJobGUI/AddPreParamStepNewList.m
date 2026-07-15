
function AddPreParamStepNewList(app, event)
%ADDPREPARAMSTEPNEWLIST Append the selected pre-processing step to the new step list
%
%   ButtonPushed callback for app.AddPreParamStepButton ("Add preparam step") on
%   the Create Parameters tab. Takes whatever "<preprocess_method> :
%   <paramset_desc>" string is currently selected in app.PreParamsStepsDrop and
%   appends it to the end of app.NewPreParamsListStepsList, the listbox that holds
%   the ordered step list being assembled for RegisterPreParamList.
%
%   Position in the listbox *is* the step order: new steps land last, and
%   MoveStepOrderClicked / DeleteStepClicked reorder or prune from there.
%   RegisterPreParamList later turns each listbox entry into one row of the
%   per-modality PreClusterParamSteps.Step / PreprocessParamSteps.Step table,
%   numbering step_number by listbox position.
%
%   A step already present in the listbox is silently ignored, so the same
%   method+paramset pair cannot appear twice in one list.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - Button ButtonPushed event (unused)
%
%   Outputs:
%       None - Appends to app.NewPreParamsListStepsList.Items
%
%   See also: DeleteStepClicked, MoveStepOrderClicked, RegisterPreParamList

new_item = app.PreParamsStepsDrop.Value;

if (sum(ismember(app.NewPreParamsListStepsList.Items, new_item)) == 0)
    app.NewPreParamsListStepsList.Items = [app.NewPreParamsListStepsList.Items new_item];
end

end