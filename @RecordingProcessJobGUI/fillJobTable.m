function fillJobTable(app, key)

if nargin < 2
    key = [];
end


app.DataTable = fetchDataDJTable(app.RecordingProcessTable, key, {'*'}, "table", "ORDER BY job_id");

%Which cells are going to be red or green colored because of status
job_errors = find([app.DataTable.status_processing_id] == app.min_job_status);
job_finished = find([app.DataTable.status_processing_id] == app.max_job_status);

idx_status_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'status_processing_id'),1);
idx_cells_red = [job_errors repmat(idx_status_job_id_column,size(job_errors))];
idx_cells_green = [job_finished repmat(idx_status_job_id_column,size(job_finished))];

removeStyle(app.JobTable);
if ~isempty(app.DataTable)
    app.JobTable.Data = table2cell(app.DataTable(:, app.COLUMNS_JOB_TABLE));
    app.setStyleCellsTable(app.JobTable, app.RED_STYLE, idx_cells_red);
    app.setStyleCellsTable(app.JobTable, app.GREEN_STYLE, idx_cells_green);
else
    app.JobTable.Data = {};
end

end