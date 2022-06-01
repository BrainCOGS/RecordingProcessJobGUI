
function ParamListSelected(app, event)

selected_steplist = app.PreProcessParamList{app.PreProcessParamList.steps_description == event.Value, {'preprocessing_method', 'paramset_desc'}};
app.PreprocessingParamsStepsList.Items = selected_steplist;

if app.py_enabled
    selected_params = app.PreProcessParamList{...
        app.PreProcessParamList.paramset_desc == app.PreprocessingParamsStepsList.Value & ...
        app.PreProcessParamList.steps_description == event.Value, 'params'};
       
    app.ParamsTextArea.Value = jsonencodepretty(selected_params);
    
end

end
    


