function RegisterPreparamFragmentClicked(app, event)
%REGISTERPREPARAMFRAGMENTCLICKED 


no_fragment = str2double(app.ListBoxFragmentRecording.Value(end));
selected_preparams_id = app.PreProcessParamList{...
    app.PreProcessParamList.(app.preprocess_steps_name_field) == app.PreprocessingParamsDropDown.Value, ...
    app.preparam_steps_idx_field };
selected_preparams_id = selected_preparams_id(1);

new_row = {no_fragment, selected_preparams_id};


idx = find(app.PreParamSelectionTable.fragment_number == no_fragment,1,'first');
if isempty(idx)
    app.PreParamSelectionTable = [app.PreParamSelectionTable; new_row];
else
    app.PreParamSelectionTable{idx, app.preparam_steps_idx_field} = selected_preparams_id;
end


app.ListBoxFragmentRecordingPreParams.Items{no_fragment+1} = [num2str(no_fragment) '-' app.PreprocessingParamsDropDown.Value];

%Select next fragment on listbox
current_idx = find(matches(app.ListBoxFragmentRecording.Items, app.ListBoxFragmentRecording.Value),1,'first');
if current_idx < length(app.ListBoxFragmentRecording.Items)
    next_idx = current_idx+1;
else
    next_idx = 1;
end

app.ListBoxFragmentRecording.Value = app.ListBoxFragmentRecording.Items{next_idx};
app.ListBoxFragmentRecordingPreParams.Value = app.ListBoxFragmentRecordingPreParams.Items{next_idx};

app.SelectedListBoxFragmentRec();

end

