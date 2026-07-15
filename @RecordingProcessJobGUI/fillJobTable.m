function fillJobTable(app, key)
%FILLJOBTABLE Populate the job table (Tab 4) with jobs and the params they use
%
%   Fetches every processing job matching the restriction KEY and writes it to
%   app.JobTable, the main table of the "Manage Processing Jobs" tab. As in
%   fillRecordingTable, two joins are queried and concatenated because a job's
%   recording may reach its session in one of two ways (see startupFcn):
%   app.RecordingProcessTable joins through recording.RecordingBehaviorSession,
%   app.RecordingProcessTable2 through recording.RecordingRecordingSession with
%   session_number forced to -1.
%
%   The job rows carry only paramset indices, so this function also builds a
%   human-readable params column set and left-joins it on job_id:
%     - ephys params come from recording_process.ProcessingEphysParams, whose
%       precluster_param_steps_id is projected to preprocess_param_steps_id so
%       the two modalities share one schema; recording_modality is stamped on;
%     - imaging params come from recording_process.ProcessingImagingParams.
%   The union is then left-joined against app.ProcessParams (on recording_modality
%   + paramset_idx) to pick up processing_method / paramset_desc, and against
%   app.PreProcessParamList (on recording_modality + preprocess_param_steps_id)
%   to pick up preprocess_param_steps_name. Those three names plus job_id are
%   merged into app.DataTable, which is cached with all columns and sorted by
%   session_date then recording_id. Only app.COLUMNS_JOB_TABLE is displayed, under
%   the headers app.COLUMNS_JOB_NAMES with app.COLUMNS_JOB_FORMAT /
%   app.COLUMNS_JOB_WIDTH.
%
%   Status colouring: the status_processing_id cell of a row is painted red when
%   the status is <= app.min_job_status (-1, i.e. errored) and green when it is
%   >= app.max_job_status (7, i.e. finished). Previous styling is cleared first
%   with removeStyle.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       key (struct)                 - Optional DataJoint restriction applied to
%                                      both job joins (e.g. .user_id,
%                                      .subject_fullname, .session_date, as built
%                                      by filterTable into app.FilterRecordingJob).
%                                      Defaults to [] = no restriction.
%
%   Outputs:
%       None - Sets app.DataTable and app.JobTable.Data, and re-applies the
%              red/green cell styles
%
%   Dependencies:
%       - fetchDataDJTable
%       - recording_process.Processing, recording_process.Status,
%         recording_process.ProcessingEphysParams,
%         recording_process.ProcessingImagingParams
%
%   See also: fillRecordingTable, jobTableSelected, fillJobStatusTable, filterTable

if nargin < 2
    key = [];
end


app.DataTable = fetchDataDJTable(app.RecordingProcessTable, key, {'*'}, "table", "ORDER BY session_date, recording_id");
extra_jobs = fetchDataDJTable(app.RecordingProcessTable2, key, {'*'}, "table", "ORDER BY session_date, recording_id");

if ~isempty(extra_jobs)
    if isempty(app.DataTable)
        app.DataTable = extra_jobs;
    else
        app.DataTable = [app.DataTable; extra_jobs];
    end
end

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