function fillJobTable(app, key)

if nargin < 2
    key = [];
end


app.DataTable = fetchDataDJTable(app.RecordingProcessTable, key, {'*'}, "table", "ORDER BY session_date, recording_id");

% merge params with job table to show params for each job
params_epys_table = proj(recording_process.ProcessingEphysParams, 'precluster_param_steps_id->preprocess_param_steps_id', 'paramset_idx');
params_epys_table = fetchDataDJTable(params_epys_table);
params_epys_table.recording_modality = repmat(categorical({'electrophysiology'}),size(params_epys_table,1),1);

params_imaging_table = fetchDataDJTable(recording_process.ProcessingImagingParams);
params_imaging_table.recording_modality = repmat({'imaging'},size(params_imaging_table,1),1);

params_all_table = [params_imaging_table; params_epys_table];

columns_join = {'paramset_idx', 'paramset_desc', 'processing_method', 'recording_modality'};
t1 = outerjoin(params_all_table, app.ProcessParams(:, columns_join), 'Keys', {'recording_modality', 'paramset_idx'}, ...
    'MergeKeys', true, 'Type', 'left');
columns_join = {'preprocess_param_steps_id', 'preprocess_param_steps_name', 'recording_modality'};
t2 = outerjoin(t1, app.PreProcessParamList(:, columns_join), 'Keys', {'recording_modality', 'preprocess_param_steps_id'},'MergeKeys', true, 'Type', 'left');


final_param_table_cols = {'job_id', 'processing_method', 'paramset_desc', 'preprocess_param_steps_name'};
app.DataTable = outerjoin(app.DataTable, t2(:,final_param_table_cols), 'MergeKeys', true, 'Type', 'left');

app.DataTable.recording_modality = cellstr(app.DataTable.recording_modality);
app.DataTable.processing_method = cellstr(app.DataTable.processing_method);
app.DataTable.paramset_desc = cellstr(app.DataTable.paramset_desc);
app.DataTable.preprocess_param_steps_name = cellstr(app.DataTable.preprocess_param_steps_name);

app.DataTable = sortrows(app.DataTable,{'session_date','recording_id'});

%Which cells are going to be red or green colored because of status
job_errors = find([app.DataTable.status_processing_id] <= app.min_job_status);
job_finished = find([app.DataTable.status_processing_id] >= app.max_job_status);

idx_status_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'status_processing_id'),1);
idx_cells_red = [job_errors repmat(idx_status_job_id_column,size(job_errors))];
idx_cells_green = [job_finished repmat(idx_status_job_id_column,size(job_finished))];

removeStyle(app.JobTable);

if ~isempty(app.DataTable)
    app.JobTable.Data = table2cell(app.DataTable(:, app.COLUMNS_JOB_TABLE));
    if ~isempty(idx_cells_red)
        app.setStyleCellsTable(app.JobTable, app.RED_STYLE, idx_cells_red);
    end
    if ~isempty(idx_cells_green)
        app.setStyleCellsTable(app.JobTable, app.GREEN_STYLE, idx_cells_green);
    end
else
    app.JobTable.Data = {};
end

end