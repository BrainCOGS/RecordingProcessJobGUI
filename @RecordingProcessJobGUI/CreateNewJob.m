
function CreateNewJob(app, event)

% Get all info to insert recording_process.Processing table

updateBusyLabel(app, false);

modality = app.modality_job_id_copy;
this_PreProcessParamList = app.PreProcessParamList(app.PreProcessParamList.recording_modality == modality, :);
this_ProcessParams = app.ProcessParams(app.ProcessParams.recording_modality == modality, :);


job_data = fetch(recording_process.Processing & app.jobid_to_copy,'recording_id', 'fragment_number', 'recording_process_pre_path');

job_data = rmfield(job_data, 'job_id');
job_data.status_processing_id = 0;

conn = dj.conn();
conn.startTransaction();
try
    %Insert recording and then recordingProcess 
    insert(recording_process.Processing, job_data);
    new_job_id = fetch(recording_process.Processing, 'ORDER BY job_id desc LIMIT 1');
    post_path = spec_fullfile('/', job_data.recording_process_pre_path, ['job_id_' num2str(new_job_id.job_id)]);
    update(recording_process.Processing & new_job_id, 'recording_process_post_path', post_path);
    
    if strcmp(app.modality_job_id_copy,'electrophysiology')
        %Create param record for job
        new_record_params.job_id = new_job_id.job_id;
        
        %Get preparam selected for new job
        preprocess_idx_field = app.preparam_steps_table_names.electrophysiology.preprocess_steps_idx_field;
        idx_selected_preparam = find(this_PreProcessParamList.(app.preprocess_steps_name_field) == app.PreprocessingParamsDropDown.Value,1,'first');
        new_record_params.(preprocess_idx_field) = this_PreProcessParamList{idx_selected_preparam, app.preparam_steps_idx_field};
        
        %Get param selected for new job
        idx_params = find(this_ProcessParams.paramset_desc == app.ProcessingParamsDropDown.Value,1,'first');
        new_record_params.(app.params_idx_field) = this_ProcessParams{idx_params, app.params_idx_field};
    
        insert(app.job_part_parms_table.electrophysiology.table_class, new_record_params);
    
    end
    conn.commitTransaction;
    
    fillJobTable(app);
    fillRecordingSubject(app);
    fillRecordingUser(app);
    app.TabGroup.SelectedTab = app.ManageProcessingJobsTab;
    
    uiconfirm(app.UIFigure,['Job was registered successfully with id: ' num2str(new_job_id.job_id)], ...
    'Job Creation Success', ...
    'Options',{'OK'}, ...
    'Icon','success');

     updateBusyLabel(app, true);

catch err
    conn.cancelTransaction
    uiconfirm(app.UIFigure,['Job was not created ' err.message], ...
    '', ...
    'Options',{'OK'}, ...
    'Icon','error');
    event.Source.Enable = 'on';
    updateBusyLabel(app, true);
    %error(err.message);
end


