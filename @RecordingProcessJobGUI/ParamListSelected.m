
function ParamListSelected(app, event)

if nargin < 2
    event.Source = app.PreprocessingParamsDropDown_2;
end

selected_steplist = app.PreProcessParamList(app.steps_description == event.Value, 'paramset_desc')
app.PreprocessingParamsStepsList.Items = selected_steplist;

end
    


