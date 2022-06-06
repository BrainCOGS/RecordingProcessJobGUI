
function PreparamStepSelected(app, event)

if app.py_enabled
    selected_list = app.PreprocessingParamsStepsList.Value;
    idx_twop = strfind(selected_list,":");
    steplist_desc = strtrim(selected_list(idx_twop+1:end));
    
    selected_params = app.PreProcessParamList{...
        app.PreProcessParamList.paramset_desc == categorical({steplist_desc}) & ...
        app.PreProcessParamList.steps_description == app.PreprocessingParamsDropDown.Value, 'params'};
    selected_params = selected_params(1);
       
    app.ParamsTextArea.Value = jsonencodepretty(selected_params);
end

end
    


