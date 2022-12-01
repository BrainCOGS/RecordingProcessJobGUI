
function RunJobDiffParams(app, event)

%Move to param selection tab but set everything to just create a job instead of recording

idx_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'job_id'),1);
app.jobid_to_copy.job_id = app.JobTable.Data{app.selectedJobRow,idx_job_id_column};

idx_modality_column = find(ismember(app.COLUMNS_JOB_TABLE,'recording_modality'),1);
app.modality_job_id_copy = app.JobTable.Data{app.selectedJobRow,idx_modality_column};

app.TabGroup.SelectedTab = app.SelectRecordingParametersTab;
app.CreateProcessingJobButton2.Enable = 'on';
app.CreateProcessingJobButton2.ButtonPushedFcn = createCallbackFcn(app, @CreateNewJob, true);
app.CreateProcessingJobButton2.Text = 'Register Job';

app.SameParamsRecordingCheckBox.Enable = 'off';
app.SamePreParamListRecordingCheckBox.Enable = 'off';

app.CreateRecordingOrJob    = false;

fillUserParams(app, app.modality_job_id_copy);
fillParams2Select(app, [], app.modality_job_id_copy);



end