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
%     - Walks app.Configuration.RecordingRootDirectory with dirwalk/visitor2 to find
%       every directory holding raw files of this modality, then drops directories
%       that are contained in another hit - for ephys each probe sits in its own
%       subdirectory, and the parent (the actual recording) is what should be
%       listed, not one entry per probe.
%     - Builds app.RecordingDirectoryTable with columns full_recording_directory,
%       times_dir (last-modified time from get_mod_time_directory), recording_dir
%       (path relative to the root) and rec_dir_dropdown (relative path + time, what
%       the user picks from), and feeds it to app.RecordingDirectoryDropDown. With
%       no hits the dropdown reads 'No recordings found' and
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
%       - dirwalk, visitor2, get_mod_time_directory
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
[rec_dirs, ~] = dirwalk(app.Configuration.RecordingRootDirectory, @visitor2, app.FileExtensions{:});
rec_dirs = rec_dirs(~cellfun('isempty',rec_dirs));

%Delete repeated directories (for probes)
if ~isempty(rec_dirs)
idx_good = 1:length(rec_dirs);
for i=1:length(rec_dirs)
    comp = rec_dirs{i};
    for j=i+1:length(rec_dirs)
        if contains(rec_dirs{j},comp)
            idx_good(idx_good == j) = [];
        end
    end
end
rec_dirs = rec_dirs(idx_good); 
end

if ~isempty(rec_dirs)

    app.RecordingDirectoryTable = cell2table(rec_dirs,'VariableNames',{'full_recording_directory'});
    app.RecordingDirectoryTable.times_dir = cellfun(@get_mod_time_directory, rec_dirs,'UniformOutput',0);
    app.RecordingDirectoryTable.recording_dir =  strrep(rec_dirs, app.Configuration.RecordingRootDirectory, '');

    app.RecordingDirectoryTable = ...
        app.RecordingDirectoryTable(~cellfun('isempty',app.RecordingDirectoryTable.recording_dir),:);

    space_cell = repmat({'           '},height(app.RecordingDirectoryTable),1);

    app.RecordingDirectoryTable.rec_dir_dropdown = strcat(app.RecordingDirectoryTable.recording_dir,space_cell, ...
        app.RecordingDirectoryTable.times_dir);

    %rec_dirs = strrep(rec_dirs, app.Configuration.RecordingRootDirectory, '');
    %rec_dirs = rec_dirs(~cellfun('isempty',rec_dirs));
    app.RecordingDirectoryDropDown.Items = app.RecordingDirectoryTable.rec_dir_dropdown;
    app.CreateProcessingJobButton.Enable = 'on';
else
    app.RecordingDirectoryDropDown.Items = {'No recordings found'};
    app.CreateProcessingJobButton.Enable = 'off';
end
    
key = cell2struct(app.Configuration.BehaviorRig','session_location');
fillSessions(app, key);    
fillPreParamsSets(app);
fillDefaultParams(app);

end

