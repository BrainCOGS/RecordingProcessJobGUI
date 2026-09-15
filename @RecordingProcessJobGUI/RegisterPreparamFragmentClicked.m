function RegisterPreparamFragmentClicked(app, event)
%REGISTERPREPARAMFRAGMENTCLICKED Assign the selected pre-param step list to one fragment
%
%   ButtonPushed callback for app.RegisterPreparamsFragment, active only when
%   app.SamePreParamListRecordingCheckBox is unchecked (i.e. fragments get
%   different pre-processing).
%
%   The tab shows two side-by-side listboxes that are read as one table, row by
%   row:
%       app.ListBoxFragmentRecording          - the fragments to assign, items
%                                               '(Probe|Fov)_0' .. '(Probe|Fov)_4'
%       app.ListBoxFragmentRecordingPreParams - what is assigned to each, items
%                                               start as '0'..'4' and are rewritten
%                                               to '<n>-<step list name>' as they
%                                               are registered
%   Row i of the left box is fragment i and row i of the right box is that
%   fragment's assignment; the two are kept scrolled/selected together here.
%
%   This takes the fragment number from the trailing character of the selected
%   left-hand item, looks up the preprocess steps id (app.preparam_steps_idx_field)
%   of the step list currently chosen in app.PreprocessingParamsDropDown, and
%   records the (fragment_number, steps id) pair in app.PreParamSelectionTable -
%   appending a row for a new fragment, or overwriting the id if that fragment was
%   already registered, so re-registering a fragment is non-destructive. That
%   table is what createDefaultParamsRecord turns into recording.DefaultParams
%   rows and what checkParamSelection checks for completeness.
%
%   Finally it labels the right-hand row and advances both listboxes to the next
%   fragment (wrapping to the first), so the user can register fragments by
%   repeatedly pressing the button, and calls SelectedListBoxFragmentRec to retitle
%   the button for the newly selected fragment.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ButtonPushed event; unused
%
%   Outputs:
%       None - Appends to / updates app.PreParamSelectionTable, relabels
%              app.ListBoxFragmentRecordingPreParams and advances the selection of
%              both fragment listboxes
%
%   See also: RegisterParamsFragmentClicked, SelectedListBoxFragmentRec,
%             SamePreParamCheckClicked, checkParamSelection


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

