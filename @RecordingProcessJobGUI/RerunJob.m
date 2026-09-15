
function RerunJob(app, event)
%RERUNJOB Reset an errored job so the automatic pipeline picks it up again
%
%   ButtonPushed callback for app.RerunJobStartButton on the "Manage Processing
%   Jobs" tab. The button is only enabled by jobTableSelected when the selected
%   job's status_processing_id is <= -1, i.e. the job errored out.
%
%   This does not re-run anything itself: it hands the job back to the automatic
%   pipeline by rewinding its status. The job_id is read from the row cached in
%   app.selectedJobRow (column located by name in app.COLUMNS_JOB_TABLE), and then
%   inside one DataJoint transaction it:
%     - sets recording_process.Processing.status_processing_id to 0 (the "ready to
%       be processed" status), and
%     - inserts a recording_process.LogStatus row recording the transition
%       -1 -> 0, timestamped now, with error_message 'Rerun of job has started'.
%   Note the logged old status is hard-coded to -1 rather than read from the job,
%   so a job reset from any other negative status still logs -1.
%
%   On success the transaction is committed, the user is notified, and the job
%   table plus its user/subject filter dropdowns are reloaded. On any failure the
%   transaction is cancelled, so the status and the log row can never disagree.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ButtonPushed event; event.Source is
%                                      app.RerunJobStartButton, re-enabled on error
%
%   Outputs:
%       None - Sets the job's status_processing_id to 0, inserts a
%              recording_process.LogStatus row, and refreshes app.JobTable
%
%   Dependencies:
%       - recording_process.Processing, recording_process.LogStatus
%       - fillJobTable, fillRecordingSubject, fillRecordingUser
%       - dj.conn (transaction handling)
%
%   See also: jobTableSelected, RunJobDiffParams, CreateNewJob, fillJobStatusTable

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


