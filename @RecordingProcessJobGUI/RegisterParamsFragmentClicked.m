function RegisterParamsFragmentClicked(app, event)
%REGISTERPREPARAMFRAGMENTCLICKED 


no_fragment = str2double(app.ListBoxFragmentRecording2.Value(end));
paramset_idx = app.ProcessParams{...
    app.ProcessParams.paramset_desc == app.ProcessingParamsDropDown.Value, ...
    'paramset_idx'};

new_row = {no_fragment, paramset_idx};

idx = find(app.ParamSelectionTable.fragment_number == no_fragment,1,'first');
if isempty(idx)
    app.ParamSelectionTable = [app.ParamSelectionTable; new_row];
else
    app.ParamSelectionTable{idx, 'paramset_idx'} = paramset_idx;
end


app.ListBoxFragmentRecording2Params.Items{no_fragment+1} = app.ProcessingParamsDropDown.Value;

end

