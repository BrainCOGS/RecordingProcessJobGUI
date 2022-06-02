
function ParamListSelected(app, event)

selected_steplist = app.PreProcessParamList{app.PreProcessParamList.steps_description == event.Value, {'preprocessing_method', 'paramset_desc'}};
selected_steplist = string(selected_steplist);
selected_steplist = [selected_steplist(:,1) repmat(": ",size(selected_steplist,1),1) selected_steplist(:,2)];

selected_steplist2 = strings(size(selected_steplist,1),1);
for i=1:length(selected_steplist2)
    selected_steplist2(i) = strjoin(selected_steplist(i,:));
end

app.PreprocessingParamsStepsList.Items = selected_steplist2;

% As if preparam step was selected to show it in textArea
app.PreparamStepSelected(event)
end
    


