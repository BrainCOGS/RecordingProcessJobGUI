function configuration_done = checkConfiguration(app)

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

