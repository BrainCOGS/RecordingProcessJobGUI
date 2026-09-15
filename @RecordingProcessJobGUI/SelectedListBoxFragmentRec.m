function SelectedListBoxFragmentRec(app, event)
%SELECTEDLISTBOXFRAGMENTREC Retitle the pre-param Register button for the selected fragment
%
%   ValueChanged callback for app.ListBoxFragmentRecording, the fragment listbox of
%   the pre-processing half of the Select Parameters tab. Rewrites the Register
%   button's label to "Register <fragment>" (e.g. "Register (Probe|Fov)_2") so it
%   always names the fragment that RegisterPreparamFragmentClicked would act on.
%
%   Also called directly by RegisterPreparamFragmentClicked after it advances the
%   listbox to the next fragment, since programmatic Value changes do not fire the
%   callback.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ListBox ValueChanged event; unused, and
%                                      omitted when called directly
%
%   Outputs:
%       None - Updates app.RegisterPreparamsFragment.Text
%
%   See also: SelectedListBoxFragmentRec2, RegisterPreparamFragmentClicked

app.RegisterPreparamsFragment.Text = ['Register ' app.ListBoxFragmentRecording.Value];

end

