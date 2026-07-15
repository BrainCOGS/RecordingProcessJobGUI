function selectRecordingRootDirectory(app, event)
%SELECTRECORDINGROOTDIRECTORY Browse for the local raw-recording root directory
%
%   ButtonPushed callback for app.SearchDirectoryButton on the System Configuration
%   tab. Opens a folder picker so the user does not have to type the recording root
%   path by hand, starting from whatever is currently in
%   app.RecordingRootDirectoryEdit.
%
%   app.UIFigure is hidden around the uigetdir call: uigetdir is a modal Java/native
%   dialog and would otherwise be drawn behind the always-on-top app window.
%
%   The picked path is only written back when uigetdir returns a char - on cancel it
%   returns 0 (double), and the existing value is left untouched. Nothing is saved
%   here; the value is only committed to app.Configuration and to
%   system_conf_job_gui.json when configureSystem runs.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - Button ButtonPushed event (unused)
%
%   Outputs:
%       None - Updates app.RecordingRootDirectoryEdit.Value if a directory was picked
%
%   See also: configureSystem, startConfiguration, postConfigurationActions


app.UIFigure.Visible = 'off';

sel_dir = uigetdir(app.RecordingRootDirectoryEdit.Value);

app.UIFigure.Visible = 'on';

if ischar(sel_dir)
    app.RecordingRootDirectoryEdit.Value = sel_dir;
end


end

