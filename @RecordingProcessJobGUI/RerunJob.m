
function RerunJob(app, event)

% Update job_id status to enable it for rerun
idx_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'job_id'),1);
job_id = app.JobTable.Data{app.selectedJobRow,idx_job_id_column};
query.job_id = job_id;


conn = dj.conn();
conn.startTransaction();
try
        
    log_status_record.job_id = job_id;
    log_status_record.status_processing_id_old = -1;
    log_status_record.status_processing_id_new = 0;
    log_status_record.status_timestamp = datestr(now, 'yyyy-mm-dd hh:MM:ss');
    log_status_record.error_message = 'Rerun of job has started';
    
    update(recording_process.Processing & query, 'status_processing_id', 0);
    insert(recording_process.LogStatus, log_status_record);
    conn.commitTransaction
    
    uiconfirm(app.UIFigure,'Job restarted successfully !', ...
        'Job Rerun Success', ...
        'Options',{'OK'}, ...
        'Icon','success');
    
    fillJobTable(app);
    fillRecordingSubject(app);
    fillRecordingUser(app);
    
    
catch err
    conn.cancelTransaction
    uiconfirm(app.UIFigure,['Rerun of job failed ' err.message], ...
        '', ...
        'Options',{'OK'}, ...
        'Icon','error');
    event.Source.Enable = 'on';
    updateBusyLabel(app, true);
    %error(err.message);
end


