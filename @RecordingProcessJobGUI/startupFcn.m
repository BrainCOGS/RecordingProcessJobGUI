function startupFcn(app)
%STARTUPFCN Build the DataJoint relations and bring the GUI up
%
%   App Designer startup function, run by runStartupFcn from the
%   RecordingProcessJobGUI constructor right after createComponents. It does the
%   one-time work that needs a live DB connection (configParams has already run
%   connect_tech), then either fills every tab or parks the GUI in the
%   "Configuration needed" state.
%
%   What it assembles:
%     - app.RecordingProcessTable / app.RecordingTable - the joined relations the
%       Manage Processing Jobs and Recording Table tabs browse. Both join in
%       recording.RecordingBehaviorSession, so they only see recordings that have
%       a behavior session.
%     - app.RecordingProcessTable2 / app.RecordingTable2 - the no-behavior twins.
%       Instead of RecordingBehaviorSession they project
%       recording.RecordingRecordingSession as
%       'date(recording_datetime)->session_date' and '-1->session_number', which is
%       how a recording with no behavior session is represented. The fill*
%       functions (fillJobTable, fillRecordingTable, fillRecordingSubject, ...)
%       query the plain relation and the '2' relation and concatenate the results.
%     - app.min_rec_status / app.max_rec_status from recording.Status, and
%       app.min_job_status / app.max_job_status (hard-coded -1 and 7) - used to
%       colour error/finished rows in the job and recording tables.
%     - app.RecordingModalityTable from recording.Modality, which also populates
%       app.ParamModalityDrop.Items on the Create Parameters tab.
%
%   It then calls checkConfiguration and branches: if the configuration is
%   complete it fills the session list for the configured BehaviorRig(s), runs
%   postConfigurationActions and FillEverything, and shows the version in
%   app.ConfigurationNeededLabel; otherwise it paints that label with
%   app.ErrorColor and tells the user configuration is needed (the user then goes
%   to the System Configuration tab). Either way fillParams runs first, so the
%   paramset tables are loaded even on an unconfigured rig.
%
%   The hasInternet flag is hard-coded true; the else branch (load_gui_vars, an
%   offline cache written by copy_gui_vars) is currently unreachable.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%
%   Outputs:
%       None - Sets app.RecordingProcessTable, app.RecordingProcessTable2,
%              app.RecordingTable, app.RecordingTable2,
%              app.RecordingModalityTable, the status min/max properties,
%              app.first_time_not_behavior, app.FilterRecordingJob and populates
%              the tabs
%
%   Dependencies:
%       - DataJoint tables: recording_process.Processing, recording_process.Status,
%         recording.Recording, recording.Status, recording.Modality,
%         recording.RecordingBehaviorSession, recording.RecordingRecordingSession,
%         subject.Subject, lab.User
%       - getPythonEnv, checkConfiguration, fillParams, fillSessions,
%         postConfigurationActions, FillEverything, updateBusyLabel
%       - fetchDataDJTable, convertTable2Categorical, copy_gui_vars, load_gui_vars
%
%   See also: RecordingProcessJobGUI, configParams, checkConfiguration,
%             FillEverything, fillParams

updateBusyLabel(app, false);
%Check if python is enabled in GUI
getPythonEnv(app);
hasInternet = true;


% By default we are doing behavior
app.first_time_not_behavior = 0;

if hasInternet
    
    % ALS, this should change if added sessions without behavior
    
    app.RecordingProcessTable = recording_process.Processing * ...
        recording.Recording * ...
        recording.RecordingBehaviorSession * ...
        proj(subject.Subject,'subject_fullname', 'user_id') * ...
        proj(lab.User,'user_id') * ...
        recording_process.Status;
    
    app.RecordingProcessTable2 = recording_process.Processing * ...
        recording.Recording * ...
        proj(recording.RecordingRecordingSession, 'subject_fullname','date(recording_datetime)->session_date','-1->session_number') * ...
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
    
    app.RecordingTable2 = recording.Recording * ...
        proj(recording.RecordingRecordingSession, 'subject_fullname','date(recording_datetime)->session_date','-1->session_number') * ...
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
