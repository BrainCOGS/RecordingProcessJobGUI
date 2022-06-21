

function CreatePreparamStepSelected(app, event)

if app.py_enabled
    selected_preparam = app.PreParamsStepsDrop.Value;
    idx_twop = strfind(selected_preparam,":");
    preparam_method = strtrim(selected_preparam(1:idx_twop-1));
    steplist_desc = strtrim(selected_preparam(idx_twop+1:end));
    
    selected_params = app.PreProcessParams{...
        app.PreProcessParams.preprocess_method == categorical({preparam_method}) & ...
        app.PreProcessParams.paramset_desc == categorical({steplist_desc}), 'params'};
    selected_params = selected_params(1);
       
    app.CreateParamsTextArea.Value = jsonencodepretty(selected_params);
    
    app.CreateParamsTextAreaTitle.Text = ['Preprocess paramset:    ' selected_preparam];
    
end

end
    

