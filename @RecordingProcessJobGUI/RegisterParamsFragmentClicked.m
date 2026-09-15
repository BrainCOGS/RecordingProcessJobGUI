function RegisterParamsFragmentClicked(app, event)
%REGISTERPARAMSFRAGMENTCLICKED Assign the selected processing paramset to one fragment
%
%   ButtonPushed callback for app.RegisterParamsFragment, active only when
%   app.SameParamsRecordingCheckBox is unchecked. The processing-paramset mirror of
%   RegisterPreparamFragmentClicked, driving the lower pair of listboxes:
%       app.ListBoxFragmentRecording2       - the fragments to assign, items
%                                             '(Probe|Fov)_0' .. '(Probe|Fov)_4'
%       app.ListBoxFragmentRecording2Params - what is assigned to each, items start
%                                             as '0'..'4' and are rewritten to
%                                             '<n>-<paramset_desc>' once registered
%   Row i of the left box is fragment i and row i of the right box is that
%   fragment's assigned paramset; the two are kept in step here.
%
%   The fragment number comes from the trailing character of the selected left-hand
%   item, and the paramset_idx (app.params_idx_field) is looked up in
%   app.ProcessParams from the paramset_desc chosen in app.ProcessingParamsDropDown.
%   The (fragment_number, paramset_idx) pair is appended to app.ParamSelectionTable,
%   or the existing row for that fragment is overwritten, so a fragment can be
%   re-registered freely. createDefaultParamsRecord later joins this table with
%   app.PreParamSelectionTable to build the recording.DefaultParams rows.
%
%   Both listboxes then advance to the next fragment (wrapping to the first) and
%   SelectedListBoxFragmentRec2 retitles the button accordingly.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ButtonPushed event; unused
%
%   Outputs:
%       None - Appends to / updates app.ParamSelectionTable, relabels
%              app.ListBoxFragmentRecording2Params and advances the selection of
%              both fragment listboxes
%
%   See also: RegisterPreparamFragmentClicked, SelectedListBoxFragmentRec2,
%             SameParamCheckClicked, checkParamSelection


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

