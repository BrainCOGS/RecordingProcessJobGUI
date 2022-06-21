
function DeleteStepClicked(app, event)

if ~isempty(app.NewPreParamsListStepsList.Value)
    this_value = app.NewPreParamsListStepsList.Value;
    idx_value = ismember(app.NewPreParamsListStepsList.Items, this_value);
    app.NewPreParamsListStepsList.Items(idx_value) = [];
    
end

end