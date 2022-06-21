
function ParamSetSelected(app, event)

if isempty(event.Value)
    return;
end

params_selected = event.Value;
idx_params = app.ProcessParams.paramset_desc == params_selected;

%Date and description
user_date = app.ProcessParams{idx_params, {'user_params', 'date_params'}};
user_date = strjoin(string(user_date));

app.UserDateParamsLabel2.Text = user_date;

if app.py_enabled
    selected_params = app.ProcessParams{idx_params, 'params'};
    selected_params = selected_params{1};
       
    app.ParamsTextArea.Value = jsonencodepretty(selected_params);
    app.ParamsTextAreaTitle.Text = ['Processing paramset:    ' params_selected];
end



end
    




