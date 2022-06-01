
function PreparamsStepSelected(app, event)

if app.py_enabled
    selected_list = app.PreprocessingParamsStepsList.Value;
    idx_twop = strfind(selected_list,":");
    steplist_desc = selected_list(idx_twop+2:end);
    
    selected_params = app.PreProcessParamList{...
        app.PreProcessParamList.paramset_desc == steplist_desc & ...
        app.PreProcessParamList.steps_description == event.Value, 'params'};
       
    app.ParamsTextArea.Value = jsonencodepretty(selected_params);
end

end
    


