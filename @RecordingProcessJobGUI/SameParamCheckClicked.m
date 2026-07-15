function SameParamCheckClicked(app, event)
%SAMEPARAMCHECKCLICKED Toggle per-fragment processing paramset assignment on or off
%
%   ValueChanged callback for app.SameParamsRecordingCheckBox ("Use same
%   processing params for all fragments (probe | fov) ?"), which is checked by
%   default. The processing-paramset mirror of SamePreParamCheckClicked.
%
%   When checked, the paramset picked in app.ProcessingParamsDropDown is broadcast
%   to every fragment, so the per-fragment controls are disabled: the fragment
%   listbox (app.ListBoxFragmentRecording2), its assigned-paramset twin
%   (app.ListBoxFragmentRecording2Params) and the Register button
%   (app.RegisterParamsFragment). createDefaultParamsRecord then writes a single
%   recording.DefaultParams row with fragment_number = 0 and
%   default_same_params_all = 1, and checkParamSelection skips its completeness
%   check.
%
%   When unchecked, the three controls are enabled and each fragment must be
%   assigned a paramset via RegisterParamsFragmentClicked, which accumulates them
%   into app.ParamSelectionTable.
%
%   The checkbox is only enabled while registering a recording
%   (createRecordingButton); RunJobDiffParams disables it.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - CheckBox ValueChanged event; unused, the
%                                      state is read from the checkbox
%
%   Outputs:
%       None - Enables/disables app.ListBoxFragmentRecording2,
%              app.RegisterParamsFragment and app.ListBoxFragmentRecording2Params
%
%   See also: SamePreParamCheckClicked, RegisterParamsFragmentClicked,
%             checkParamSelection, createDefaultParamsRecord

if app.SameParamsRecordingCheckBox.Value
    app.ListBoxFragmentRecording2.Enable = 'off';
    app.RegisterParamsFragment.Enable = 'off';
    app.ListBoxFragmentRecording2Params.Enable = 'off';
else
    app.ListBoxFragmentRecording2.Enable = 'on';
    app.RegisterParamsFragment.Enable = 'on';
    app.ListBoxFragmentRecording2Params.Enable = 'on';
end

end

