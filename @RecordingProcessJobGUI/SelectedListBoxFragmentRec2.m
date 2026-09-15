function SelectedListBoxFragmentRec2(app, event)
%SELECTEDLISTBOXFRAGMENTREC2 Retitle the params Register button for the selected fragment
%
%   ValueChanged callback for app.ListBoxFragmentRecording2, the fragment listbox of
%   the processing half of the Select Parameters tab. Rewrites the Register button's
%   label to "Register <fragment>" (e.g. "Register (Probe|Fov)_2") so it always
%   names the fragment that RegisterParamsFragmentClicked would act on.
%
%   Also called directly by RegisterParamsFragmentClicked after it advances the
%   listbox to the next fragment, since programmatic Value changes do not fire the
%   callback.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ListBox ValueChanged event; unused, and
%                                      omitted when called directly
%
%   Outputs:
%       None - Updates app.RegisterParamsFragment.Text
%
%   See also: SelectedListBoxFragmentRec, RegisterParamsFragmentClicked

app.RegisterParamsFragment.Text = ['Register ' app.ListBoxFragmentRecording2.Value];

end

