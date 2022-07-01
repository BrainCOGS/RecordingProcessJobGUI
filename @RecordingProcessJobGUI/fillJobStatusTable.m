function fillJobStatusTable(app, key)

if nargin < 2
    key = [];
end

app.JobHistoryTable.Data = {};

columns = [app.COLUMNS_JOB_STATUS_TABLE, {'ORDER BY status_timestamp desc'}];
job_status_history = fetch(app.job_id_history_table_class() & key,columns{:});

%Which cells are going to be red or green colored because of status
job_errors = find([job_status_history.status_processing_id_new] == app.min_job_status);
job_errors = job_errors(:);
job_finished = find([job_status_history.status_processing_id_new] == app.max_job_status);
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



