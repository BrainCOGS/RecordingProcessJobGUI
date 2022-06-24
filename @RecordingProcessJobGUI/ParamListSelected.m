
function ParamListSelected(app, event)

if isempty(event.Value)
    app.PreprocessingParamsStepsList.Items = {};
    app.PreParamsDescriptionLabel2.Text = '';
    app.UserDatePreParamsLabel2.Text = '';
    
    % IF list empty, try to select from paramset itself
    if ~isempty(app.ProcessingParamsDropDown.Items)   
        event2 = app.ProcessingParamsDropDown;
        ParamSetSelected(app, event2)
    end
    return
end

%Idx all lists
idx_selected_lists = app.PreProcessParamList.(app.preprocess_steps_name_field) == event.Value;
idx_selected_list1 = find(idx_selected_lists, 1, 'first');

%Date and description
user_date = app.PreProcessParamList{idx_selected_list1, {'user_params', 'date_params'}};
user_date = strjoin(string(user_date));
list_description = app.PreProcessParamList{idx_selected_list1, {app.preprocess_steps_desc_field}}; 


%Get steps
selected_steplist = app.PreProcessParamList{idx_selected_lists, {app.preparam_methods_method_field; app.params_desc_field}};
selected_steplist = string(selected_steplist);
selected_steplist = [selected_steplist(:,1) repmat(": ",size(selected_steplist,1),1) selected_steplist(:,2)];

selected_steplist2 = strings(size(selected_steplist,1),1);
for i=1:length(selected_steplist2)
    selected_steplist2(i) = strjoin(selected_steplist(i,:));
end

app.PreParamsDescriptionLabel2.Text = list_description;
app.UserDatePreParamsLabel2.Text = user_date;
app.PreprocessingParamsStepsList.Items = selected_steplist2;

app.PreprocessingParamsStepsList.Value = selected_steplist2(1);

% As if preparam step was selected to show it in textArea
app.PreparamStepSelected(event)
end
    


