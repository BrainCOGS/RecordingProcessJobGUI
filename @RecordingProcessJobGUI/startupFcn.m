function startupFcn(app)

updateBusyLabel(app, 0);
setenv('DB_PREFIX', 'u19_')
connect_tech();

prefix = getenv('DB_PREFIX');
app.RecordingSchema = dj.Schema(dj.conn, 'recording', [prefix 'recording']);
app.ProcessJobsSchema = dj.Schema(dj.conn, 'recording_process', [prefix 'recording_process']);

% ALS, this should change if added sessions without behavior

app.RecordingProcessTable = app.ProcessJobsSchema.v.Processing * ...
    app.RecordingSchema.v.Recording * ...
    app.RecordingSchema.v.RecordingBehaviorSession * ...
    proj(subject.Subject,'subject_fullname', 'user_id') * ...
    proj(lab.User,'user_id') * ...
    app.ProcessJobsSchema.v.Status;


app.RecordingTable = app.RecordingSchema.v.Recording * ...
    app.RecordingSchema.v.RecordingBehaviorSession * ...
    proj(subject.Subject,'subject_fullname', 'user_id') * ...
    proj(lab.User,'user_id') * ...
    app.RecordingSchema.v.Status;


configuration_done = checkConfiguration(app);

if configuration_done
    postConfigurationActions(app);
    
    key.session_location = app.Configuration.BehaviorRig;
    fillSessions(app, key);
    fillParams(app);
    
    app.DropdownParamsPrevious = app.PreprocessingParamsDropDown_2;
    ParamsSelected(app);
    fillTable(app);
    fillTableRT(app);
    fillRecordingUser(app);
    fillRecordingSubject(app);
    fillRecordingUserRT(app);
    fillRecordingSubjectRT(app);
    app.FilterRecordingJob = struct;
else
    app.ConfigurationNeededLabel.BackgroundColor = app.ErrorColor;
    app.ConfigurationNeededLabel.Text = {'Configuration'; 'needed'};

end

updateBusyLabel(app, 1);

end
