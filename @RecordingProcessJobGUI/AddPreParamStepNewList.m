
function AddPreParamStepNewList(app, event)

new_item = app.PreParamsStepsDrop.Value;

if (sum(ismember(app.NewPreParamsListStepsList.Items, new_item)) == 0)
    app.NewPreParamsListStepsList.Items = [app.NewPreParamsListStepsList.Items new_item];
end

end