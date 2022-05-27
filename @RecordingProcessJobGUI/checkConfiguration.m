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
    else
        app.([conf_fields{i} 'Label']).Text = app.Configuration.(conf_fields{i});
    end
end
        
end

