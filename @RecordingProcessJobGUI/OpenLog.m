
function OpenLog(app, event)
%OPENLOG Open the output or error log file of the selected job in a text editor
%
%   Shared ButtonPushed callback for app.OpenOutLogButton and
%   app.OpenErrLogButton on the "Manage Processing Jobs" tab. The two buttons are
%   told apart by event.Source: the Output button reads from app.OutputLogsPath,
%   anything else (i.e. the Error button) from app.ErrorLogsPath. Both paths are
%   set in configParams and live under <ProcessedDataPath>/LOGS/.
%
%   The pipeline names each log after the job, so the file is simply
%   <path>/job_id_<job_id>.log, with the job_id taken from the row cached in
%   app.selectedJobRow (column located by name in app.COLUMNS_JOB_TABLE). It is
%   opened with notepad on Windows and `open` on macOS; on Linux nothing happens.
%   Nothing happens either if no job row has been selected yet.
%
%   Note the log only exists once the pipeline has actually run the job, and no
%   existence check is done: a missing file surfaces as notepad's own
%   "cannot find" prompt rather than a GUI error.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ButtonPushed event; event.Source selects
%                                      the output vs error log
%
%   Outputs:
%       None - Launches an external text editor on the job's log file
%
%   See also: jobTableSelected, OpenExtGUI, OpenExtGUI2, fillJobStatusTable

if event.Source == app.OpenOutLogButton
    path = app.OutputLogsPath;
else
    path = app.ErrorLogsPath;
end

if ~isempty(app.selectedJobRow)
    
    idx_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'job_id'),1);
    job_id = app.JobTable.Data{app.selectedJobRow(1),idx_job_id_column};
    
    fullpath = fullfile(path, ['job_id_' num2str(job_id) '.log']);
    
    if ispc
        system(['notepad ' fullpath]);
    elseif ismac
        system(['open ' fullpath]);
    end
    
end

end