
function ParamSetSelected(app, event)

if app.py_enabled
    params_selected = event.Value;
    
    selected_params = app.ProcessParams{...
        app.ProcessParams.paramset_desc == params_selected, 'params'};
    selected_params = selected_params{1};
       
    app.ParamsTextArea.Value = jsonencodepretty(selected_params);
end

end
    




