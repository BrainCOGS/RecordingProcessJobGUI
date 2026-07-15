function fillJobStatusTable(app, key)
%FILLJOBSTATUSTABLE Show a job's status history in the Job Status History table
%
%   Fetches the status history matching the restriction KEY (in practice
%   struct('job_id', <id>), passed by jobTableSelected) from
%   app.job_id_history_table_class (recording_process.LogStatus), newest entry
%   first, and writes it to app.JobHistoryTable on the "Manage Processing Jobs"
%   tab. The table is blanked first so a job with no history shows empty rather
%   than the previous job's log. Only the columns named in
%   app.COLUMNS_JOB_STATUS_TABLE are fetched, so the struct field order matches
%   the widget's column order (app.COLUMNS_JOB_STATUS_NAMES) and the result can be
%   dumped straight in via struct2cell.
%
%   Status colouring: the status_processing_id_new cell of each history row is
%   painted red when the new status is <= app.min_job_status (-1, errored) and
%   green when it is >= app.max_job_status (7, finished). Previous styling is
%   cleared first with removeStyle.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       key (struct)                 - Optional DataJoint restriction on the log
%                                      table, normally .job_id. Defaults to [],
%                                      which fetches the history of every job.
%
%   Outputs:
%       None - Updates app.JobHistoryTable.Data and its red/green styles
%
%   Dependencies:
%       - recording_process.LogStatus (via app.job_id_history_table_class)
%
%   See also: jobTableSelected, fillJobTable, recordingTableSelected, setStyleCellsTable

if nargin < 2
    key = [];
end

app.JobHistoryTable.Data = {};

columns = [app.COLUMNS_JOB_STATUS_TABLE, {'ORDER BY status_timestamp desc'}];
job_status_history = fetch(app.job_id_history_table_class() & key,columns{:});

%Which cells are going to be red or green colored because of status
job_errors = find([job_status_history.status_processing_id_new] <= app.min_job_status);
job_errors = job_errors(:);
job_finished = find([job_status_history.status_processing_id_new] >= app.max_job_status);
job_finished = job_finished(:);

idx_status_job_id_column = find(ismember(app.COLUMNS_JOB_STATUS_TABLE,'status_processing_id_new'),1);
idx_cells_red = [job_errors repmat(idx_status_job_id_column,size(job_errors))];
idx_cells_green = [job_finished repmat(idx_status_job_id_column,size(job_finished))];

removeStyle(app.JobHistoryTable);
if ~isempty(job_status_history)
    data = struct2cell(job_status_history);
    app.JobHistoryTable.Data = data';
    app.setStyleCellsTable(app.JobHistoryTable, app.RED_STYLE, idx_cells_red);
    app.setStyleCellsTable(app.JobHistoryTable, app.GREEN_STYLE, idx_cells_green);
end

end



