function RegisterPreparamFragmentClicked(app, event)
%REGISTERPREPARAMFRAGMENTCLICKED 


no_fragment = str2double(app.ListBoxFragmentRecording.Value(end));
selected_preparams_id = app.PreProcessParamList{...
    app.PreProcessParamList.steps_description == app.PreprocessingParamsDropDown.Value, ...
    'preprocessing_param_steps_id'};
selected_preparams_id = selected_preparams_id(1);

new_row = {no_fragment, selected_preparams_id};


idx = find(app.PreParamSelectionTable.fragment_number == no_fragment,1,'first');
if isempty(idx)
    app.PreParamSelectionTable = [app.PreParamSelectionTable; new_row];
else
    app.PreParamSelectionTable{idx, 'preparam_list_id'} = selected_preparams_id;
end


app.ListBoxFragmentRecordingPreParams.Items{no_fragment+1} = app.PreprocessingParamsDropDown.Value;

end

