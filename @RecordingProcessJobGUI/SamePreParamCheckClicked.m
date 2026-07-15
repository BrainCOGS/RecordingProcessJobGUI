function SamePreParamCheckClicked(app, event)
%SAMEPREPARAMCHECKCLICKED Toggle per-fragment pre-param assignment on or off
%
%   ValueChanged callback for app.SamePreParamListRecordingCheckBox ("Use same
%   pre-params list for all fragments (probe | fov) ?"), which is checked by
%   default.
%
%   When checked, the pre-processing step list picked in
%   app.PreprocessingParamsDropDown is broadcast to every fragment of the
%   recording, so the per-fragment machinery is switched off: the fragment listbox
%   (app.ListBoxFragmentRecording), its assigned-list twin
%   (app.ListBoxFragmentRecordingPreParams) and the Register button
%   (app.RegisterPreparamsFragment) are all disabled. Downstream,
%   createDefaultParamsRecord then writes a single recording.DefaultParams row
%   with fragment_number = 0 and default_same_preparams_all = 1, and
%   checkParamSelection skips its completeness check entirely.
%
%   When unchecked, the three controls are enabled and the user must register a
%   step list for each fragment individually via RegisterPreparamFragmentClicked,
%   which accumulates them into app.PreParamSelectionTable.
%
%   The checkbox itself is only enabled while registering a recording
%   (createRecordingButton); RunJobDiffParams disables it, since a job targets one
%   known fragment.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - CheckBox ValueChanged event; unused, the
%                                      state is read from the checkbox
%
%   Outputs:
%       None - Enables/disables app.ListBoxFragmentRecording,
%              app.RegisterPreparamsFragment and
%              app.ListBoxFragmentRecordingPreParams
%
%   See also: SameParamCheckClicked, RegisterPreparamFragmentClicked,
%             checkParamSelection, createDefaultParamsRecord

if app.SamePreParamListRecordingCheckBox.Value
    app.ListBoxFragmentRecording.Enable = 'off';
    app.RegisterPreparamsFragment.Enable = 'off';
    app.ListBoxFragmentRecordingPreParams.Enable = 'off';
else
    app.ListBoxFragmentRecording.Enable = 'on';
    app.RegisterPreparamsFragment.Enable = 'on';
    app.ListBoxFragmentRecordingPreParams.Enable = 'on';
end

end

