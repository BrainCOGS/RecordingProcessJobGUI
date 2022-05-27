function postConfigurationActions(app)

app.ConfigurationNeededLabel.Text = '';
app.ConfigurationNeededLabel.BackgroundColor = 'none';

%Write configuration on the front to inform user
conf_label = app.InfoStyle;
conf_label = conf_label + "<b>System:</b> " + string(app.Configuration.System);
conf_label = conf_label + "&nbsp&nbsp&nbsp<b>Behavior Rig:</b> " + string(app.Configuration.BehaviorRig);
conf_label = conf_label + "&nbsp&nbsp&nbsp<b>Modality:</b> " + string(app.Configuration.RecordingModality);
conf_label = conf_label + "&nbsp&nbsp<br>";
conf_label = conf_label + "<b>Recording root directory:</b> " + string(app.Configuration.RecordingRootDirectory);
conf_label = conf_label + "&nbsp&nbsp</p>";
app.ConfigurationLabel.HTMLSource = conf_label;


app.TabGroup.SelectedTab = app.TabGroup.Children(1);

% Get file extension for this system
query_modality.recording_modality = app.Configuration.RecordingModality;

%rec_schema = dj.Schema(dj.conn, 'recording', 'u19_recording');
%app.FileExtensions = fetch1(app.RecordingSchema.v.RecordingModality & query_modality, 'recording_file_extensions');
app.FileExtensions = fetch1(app.RecordingSchema.v.RecordingModality & query_modality, 'recording_file_pattern');
%app.FileExtensions = fetch1(lab.RecordingModality & query_modality, 'recording_file_extensions');
%app.FileExtensions = strcat('^.*\', app.FileExtensions);

%ALS Hardoced
app.FileExtensions = {'^.*\g0'};

%Fill possible recording directories from modality and selected root dir
[rec_dirs, ~] = dirwalk(app.Configuration.RecordingRootDirectory, @visitor2, app.FileExtensions{:});
rec_dirs = rec_dirs(~cellfun('isempty',rec_dirs));

if ~isempty(rec_dirs)
    rec_dirs = strrep(rec_dirs, app.Configuration.RecordingRootDirectory, '');
    rec_dirs = rec_dirs(~cellfun('isempty',rec_dirs));
    app.RecordingDirectoryDropDown.Items = rec_dirs;
else
    app.RecordingDirectoryDropDown.Items = {'dummy'};
end
    
key.session_location = app.Configuration.BehaviorRig;
fillSessions(app, key);    

end

