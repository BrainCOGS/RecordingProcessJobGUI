
function DeleteStepClicked(app, event)
%DELETESTEPCLICKED Remove the selected step from the new pre-processing step list
%
%   ButtonPushed callback for app.DeleteStep (the "X" button) on the Create
%   Parameters tab. Drops the currently selected entry from
%   app.NewPreParamsListStepsList, the listbox holding the ordered step list being
%   assembled for RegisterPreParamList. The step is matched by its
%   "<preprocess_method> : <paramset_desc>" text rather than by index, and does
%   nothing when the listbox has no selection.
%
%   Only the in-progress listbox is touched - no DB row is deleted, and the
%   underlying paramsets in app.PreProcessParams are untouched. There is no
%   explicit renumbering here: step_number is derived from listbox position when
%   RegisterPreParamList writes the list, so the remaining steps close the gap
%   automatically.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - Button ButtonPushed event (unused)
%
%   Outputs:
%       None - Removes the selected entry from app.NewPreParamsListStepsList.Items
%
%   See also: AddPreParamStepNewList, MoveStepOrderClicked, RegisterPreParamList

if ~isempty(app.NewPreParamsListStepsList.Value)
    this_value = app.NewPreParamsListStepsList.Value;
    idx_value = ismember(app.NewPreParamsListStepsList.Items, this_value);
    app.NewPreParamsListStepsList.Items(idx_value) = [];
    
end

end