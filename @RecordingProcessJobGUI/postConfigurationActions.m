function postConfigurationActions(app)
%POSTCONFIGURATIONACTIONS Bring the GUI into its working state once configuration is valid
%
%   Everything that can only be done once app.Configuration is known to be complete.
%   Called from startupFcn when checkConfiguration returns true, and from
%   configureSystem right after a new configuration is saved. This is what turns the
%   "Configuration needed" GUI into a usable one, so it must be safe to run twice.
%
%   What it sets up, in order:
%     - Clears the red "Configuration needed" banner: app.ConfigurationNeededLabel
%       becomes 'Version: <app.Version>' with no background colour.
%     - Renders the live configuration into app.ConfigurationLabel as HTML (System /
%       Behavior Rig / Modality on one line, recording root directory on the next),
%       so the user can always see which rig and modality the GUI thinks it is on.
%     - Jumps to the first tab (Add Recording), the tab the user actually works in.
%     - Resolves app.FileExtensions from app.AllFileExtensions for this modality -
%       the regexps that identify a raw recording ('^.*\g0' for electrophysiology;
%       .tiff/.tif/.avi for imaging). These are set by configParams.
%     - Fills the Recording Directory dropdown with fillRecordingDirectories: every
%       folder under app.Configuration.RecordingRootDirectory holding raw files of
%       this modality, with nested hits collapsed into their top folder. With no hits the dropdown reads 'No recordings found' and
%       app.CreateProcessingJobButton is disabled.
%     - Fills the behavior sessions for the configured behavior rig(s) - each rig
%       name becomes a session_location key - plus the pre-param step lists and the
%       default params for this modality.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%
%   Outputs:
%       None - Sets app.FileExtensions and app.RecordingDirectoryTable, updates
%              app.ConfigurationNeededLabel, app.ConfigurationLabel,
%              app.RecordingDirectoryDropDown, app.CreateProcessingJobButton and the
%              selected tab, and populates the session / params dropdowns
%
%   Dependencies:
%       - fillRecordingDirectories
%       - fillSessions, fillPreParamsSets, fillDefaultParams
%       - configParams (must have run: provides app.AllFileExtensions)
%
%   See also: checkConfiguration, configureSystem, FillEverything, startupFcn

app.ConfigurationNeededLabel.Text = {['Version: ', app.Version]};
app.ConfigurationNeededLabel.BackgroundColor = 'none';

%Write configuration on the front to inform user

behavior_rig_str = strjoin(string(app.Configuration.BehaviorRig), ', ');

conf_label = app.InfoStyle;
conf_label = conf_label + "<b>System:</b> " + string(app.Configuration.System);
conf_label = conf_label + "&nbsp&nbsp&nbsp<b>Behavior Rig:</b> " + behavior_rig_str;
conf_label = conf_label + "&nbsp&nbsp&nbsp<b>Modality:</b> " + string(app.Configuration.RecordingModality);
conf_label = conf_label + "&nbsp&nbsp<br>";
conf_label = conf_label + "<b>Recording root directory:</b> " + string(app.Configuration.RecordingRootDirectory);
conf_label = conf_label + "&nbsp&nbsp</p>";
app.ConfigurationLabel.HTMLSource = conf_label;


app.TabGroup.SelectedTab = app.TabGroup.Children(1);

% Get file extension for this system
app.FileExtensions = app.AllFileExtensions.(app.Configuration.RecordingModality);

%Fill possible recording directories from modality and selected root dir
fillRecordingDirectories(app);
    
key = cell2struct(app.Configuration.BehaviorRig','session_location');
fillSessions(app, key);    
fillPreParamsSets(app);
fillDefaultParams(app);

end

