function RegisterParamsFragmentClicked(app, event)
%REGISTERPREPARAMFRAGMENTCLICKED 


no_fragment = str2double(app.ListBoxFragmentRecording2.Value(end));
paramset_idx = app.ProcessParams{...
    app.ProcessParams.paramset_desc == app.ProcessingParamsDropDown.Value, ...
    app.params_idx_field};
paramset_idx = paramset_idx(1);

new_row = {no_fragment, paramset_idx};

idx = find(app.ParamSelectionTable.fragment_number == no_fragment,1,'first');
if isempty(idx)
    app.ParamSelectionTable = [app.ParamSelectionTable; new_row];
else
    app.ParamSelectionTable{idx, app.params_idx_field} = paramset_idx;
end


app.ListBoxFragmentRecording2Params.Items{no_fragment+1} = [num2str(no_fragment) '-' app.ProcessingParamsDropDown.Value];

%Select next fragment on listbox
current_idx = find(matches(app.ListBoxFragmentRecording2.Items, app.ListBoxFragmentRecording2.Value),1,'first');
if current_idx < length(app.ListBoxFragmentRecording2.Items)
    next_idx = current_idx+1;
else
    next_idx = 1;
end

app.ListBoxFragmentRecording2.Value = app.ListBoxFragmentRecording2.Items{next_idx};
app.ListBoxFragmentRecording2Params.Value = app.ListBoxFragmentRecording2Params.Items{next_idx};

app.SelectedListBoxFragmentRec2();

end

