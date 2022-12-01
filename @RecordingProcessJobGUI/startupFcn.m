function startupFcn(app)

updateBusyLabel(app, false);
%Check if python is enabled in GUI
getPythonEnv(app);
hasInternet = true;


if hasInternet
    
    % ALS, this should change if added sessions without behavior
    
    app.RecordingProcessTable = recording_process.Processing * ...
        recording.Recording * ...
        recording.RecordingBehaviorSession * ...
        proj(subject.Subject,'subject_fullname', 'user_id') * ...
        proj(lab.User,'user_id') * ...
        recording_process.Status;
    
    job_statuses = fetchn(recording_process.Status,'status_processing_id');
    app.min_job_status = -1;
    app.max_job_status = 7;
    
    
    app.RecordingTable = recording.Recording * ...
        recording.RecordingBehaviorSession * ...
        proj(subject.Subject,'subject_fullname', 'user_id') * ...
        proj(lab.User,'user_id') * ...
        recording.Status;
    
    recording_statuses = fetchn(recording.Status,'status_recording_id');
    app.min_rec_status = min(recording_statuses);
    app.max_rec_status = max(recording_statuses);
    
    app.RecordingModalityTable = fetchDataDJTable(recording.Modality, [], {'*'}, "table", [], true);
    app.RecordingModalityTable = convertTable2Categorical(app.RecordingModalityTable);
    app.ParamModalityDrop.Items = app.RecordingModalityTable.recording_modality;
    
    configuration_done = checkConfiguration(app);
    fillParams(app);

    if configuration_done
        
        key = cell2struct(app.Configuration.BehaviorRig', 'session_location');
        fillSessions(app, key);
        postConfigurationActions(app);

        FillEverything(app);
        
        app.ParamModalityDrop.Value = app.Configuration.RecordingModality;
        app.FilterRecordingJob = struct;
        app.ConfigurationNeededLabel.Text = {['Version: ', app.Version]};
    else
        app.ConfigurationNeededLabel.BackgroundColor = app.ErrorColor;
        app.ConfigurationNeededLabel.Text = {['Version: ', app.Version]; 'Configuration needed'};
        
    end
    
    copy_gui_vars(app);
    
else
    app = load_gui_vars(app);
end

updateBusyLabel(app, 1);

end
