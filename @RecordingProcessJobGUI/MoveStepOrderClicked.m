
function MoveStepOrderClicked(app, event)
%MOVESTEPORDERCLICKED Move the selected step up or down in the new pre-processing step list
%
%   Shared ButtonPushed callback for app.MoveStepUp ("^") and app.MoveStepDown
%   ("v") on the Create Parameters tab. event.Source is compared against
%   app.MoveStepUp to pick the direction, then the selected entry of
%   app.NewPreParamsListStepsList is swapped with its immediate neighbour by
%   building a permutation of 1:numel(Items) and reindexing Items with it.
%
%   Order matters: app.NewPreParamsListStepsList is the ordered step list being
%   assembled, and RegisterPreParamList numbers step_number by listbox position
%   when it writes the rows, so moving an entry here is what renumbers the steps.
%   Nothing is written to the DB by this callback.
%
%   No-ops when the listbox has no selection, when "up" is pressed on the first
%   entry, or when "down" is pressed on the last. Because the listbox Value is the
%   entry text (and AddPreParamStepNewList keeps entries unique), the selection
%   follows the step as it moves.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - Button ButtonPushed event; event.Source
%                                      selects the direction (app.MoveStepUp =
%                                      up, otherwise down)
%
%   Outputs:
%       None - Reorders app.NewPreParamsListStepsList.Items
%
%   See also: AddPreParamStepNewList, DeleteStepClicked, RegisterPreParamList

if event.Source == app.MoveStepUp
    direction = "up";
else
    direction = "down";
end

if ~isempty(app.NewPreParamsListStepsList.Value)
    this_value = app.NewPreParamsListStepsList.Value;
    idx_value = find(ismember(app.NewPreParamsListStepsList.Items, this_value));
    
    index_values = 1:length(app.NewPreParamsListStepsList.Items);
    
    if direction == "up" && idx_value ~= 1
        index_values(idx_value-1) = idx_value;
        index_values(idx_value)   = idx_value-1;
        
    elseif direction == "down" && idx_value ~= length(app.NewPreParamsListStepsList.Items)
        index_values(idx_value+1) = idx_value;
        index_values(idx_value)   = idx_value+1;
    end
    
    app.NewPreParamsListStepsList.Items = app.NewPreParamsListStepsList.Items(index_values);
end

end