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
    
    
    app.RecordingTable = recording.Recording * ...
        recording.RecordingBehaviorSession * ...
        proj(subject.Subject,'subject_fullname', 'user_id') * ...
        proj(lab.User,'user_id') * ...
        recording.Status;
    
    app.RecordingModalityTable = fetchDataDJTable(recording.Modality, [], {'*'}, "table", [], true);
    app.RecordingModalityTable = convertTable2Categorical(app.RecordingModalityTable);
    app.ParamModalityDrop.Items = app.RecordingModalityTable.recording_modality;
    
    configuration_done = checkConfiguration(app);
    
    if configuration_done
        
        key.session_location = app.Configuration.BehaviorRig;
        fillSessions(app, key);
        fillParams(app);
        postConfigurationActions(app);

        fillTable(app);
        fillTableRT(app);
        fillRecordingUser(app);
        fillRecordingSubject(app);
        fillRecordingUserRT(app);
        fillUsers(app, 'active_gui_user=1 and primary_tech="N/A"');
        fillRecordingSubjectRT(app);
        
        app.ParamModalityDrop.Value = app.Configuration.RecordingModality;
        app.FilterRecordingJob = struct;
    else
        app.ConfigurationNeededLabel.BackgroundColor = app.ErrorColor;
        app.ConfigurationNeededLabel.Text = {'Configuration'; 'needed'};
        
    end
    
    copy_gui_vars(app);
    
else
    app = load_gui_vars(app);
end

updateBusyLabel(app, 1);

end
