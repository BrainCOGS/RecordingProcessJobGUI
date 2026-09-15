function configuration_done = checkConfiguration(app)
%CHECKCONFIGURATION Load this rig's system configuration and report whether it is complete
%
%   Reads the per-rig configuration file (app.ConfFileName =
%   'system_conf_job_gui.json', at the repo root) into app.Configuration and decides
%   whether this machine has been set up yet. Called by startupFcn before anything
%   else is filled in, and again by configureSystem right after a new configuration
%   is written, so it is the single place that defines what "configured" means.
%
%   The file has four fields, all of which the rest of the GUI depends on:
%       System                 - recording system name, a lab.Location with
%                                system_type="recording" (e.g. '185A-Recording')
%       RecordingModality      - 'electrophysiology' or 'imaging'; keys almost every
%                                per-modality registry set up by configParams
%       RecordingRootDirectory - local directory that is walked for raw recordings
%       BehaviorRig            - name(s) of the behavior rig(s) this system is paired
%                                with, i.e. lab.Location with system_type="rig"
%
%   ANY empty field means not configured: the check is a plain isempty over
%   fieldnames(app.Configuration), so one blank field returns configuration_done = 0
%   and every field is then blanked out, leaving the caller to put the GUI in the
%   "Configuration needed" state and force the user through the System Configuration
%   tab.
%
%   BehaviorRig is always normalized to a cell array, because a rig may be paired
%   with several behavior rigs: jsondecode yields a char for a single rig and a cell
%   array for a JSON list, and downstream callers (postConfigurationActions,
%   startConfiguration) index it as a list. Note this normalization only applies on
%   the configured path - the not-configured branch resets BehaviorRig to '' (char).
%
%   It also resolves app.RootFolder from the location of RecordingProcessJobGUI on
%   the path and addpath's it when not deployed, which is what makes the repo-root
%   helpers (loadJSONfile, fetchDataDJTable, ...) callable.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%
%   Outputs:
%       configuration_done - 1 if every configuration field is non-empty, 0 otherwise
%       None               - Sets app.RootFolder, app.ConfFileFullName and
%                            app.Configuration; on success fills the System
%                            Configuration tab labels (app.SystemLabel,
%                            app.RecordingModalityLabel,
%                            app.RecordingRootDirectoryLabel,
%                            app.AssociatedBehaviorRigListBox.Items,
%                            app.AssociatedBehaviorRigLabel)
%
%   Errors:
%       'configuration file not found' if system_conf_job_gui.json is missing from
%       app.RootFolder. The file is expected to exist with empty fields on a fresh
%       rig - an absent file is a broken checkout, not an unconfigured rig.
%
%   Dependencies:
%       - loadJSONfile
%
%   See also: startupFcn, configureSystem, postConfigurationActions,
%             startConfiguration

configuration_done = 1;
app.RootFolder = fileparts(fileparts(which('RecordingProcessJobGUI')));

if (~isdeployed)
    addpath(app.RootFolder);
    %addpath(genpath('/Users/alvaros/Documents/MATLAB/BrainCogsProjects/Datajoint_proj/U19-pipeline-matlab'))
end

%Read configuration field
app.ConfFileFullName = fullfile(app.RootFolder, app.ConfFileName);
if isfile(app.ConfFileFullName)
    app.Configuration = loadJSONfile(app.ConfFileFullName);
else
    error('configuration file not found')
end

conf_fields = fieldnames(app.Configuration);

%Check configuration fields
for i=1:length(conf_fields)
    if isempty(app.Configuration.(conf_fields{i}))
        configuration_done = 0;
    end
end

%Always read behavior rig as a "list"
if ~iscell(app.Configuration.BehaviorRig)
    app.Configuration.BehaviorRig = {app.Configuration.BehaviorRig};
end

%configuration_done = 0
if configuration_done
    app.SystemLabel.Text = app.Configuration.System;
    app.RecordingModalityLabel.Text = app.Configuration.RecordingModality;
    app.RecordingRootDirectoryLabel.Text = app.Configuration.RecordingRootDirectory;
    app.AssociatedBehaviorRigListBox.Items = cellstr(app.Configuration.BehaviorRig);
    app.AssociatedBehaviorRigLabel.Text = strjoin(app.Configuration.BehaviorRig, ', ');
else
    app.Configuration.System = '';
    app.Configuration.RecordingModality = '';
    app.Configuration.RecordingRootDirectory = '';
    app.Configuration.BehaviorRig = '';
        
end

