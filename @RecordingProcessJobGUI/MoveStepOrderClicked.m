
function MoveStepOrderClicked(app, event)

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