
function RunJobDiffParams(app, event)
%RUNJOBDIFFPARAMS Send the selected job to Tab 2 to be cloned with new parameters
%
%   ButtonPushed callback for app.RunJobDiffParamsButton on the "Manage Processing
%   Jobs" tab. It writes no data itself: it remembers which job is being cloned
%   and re-purposes the "Select Parameters" tab (normally the last step of
%   registering a new recording) into a params picker for a single new job.
%
%   From the row cached in app.selectedJobRow it stores app.jobid_to_copy.job_id
%   and app.modality_job_id_copy (columns located by name in
%   app.COLUMNS_JOB_TABLE), then switches to app.SelectRecordingParametersTab and
%   rewires it:
%     - app.CreateProcessingJobButton2 is relabelled 'Register Job' and its
%       callback swapped to CreateNewJob, which is what actually inserts the clone;
%     - app.SameParamsRecordingCheckBox and app.SamePreParamListRecordingCheckBox
%       are disabled, since there is only one fragment (the cloned job's) to pick
%       params for, so "same params for the whole recording" is meaningless;
%     - app.CreateRecordingOrJob is set false, the flag the params tab reads to
%       mean "creating a job only, not a whole recording".
%   Finally the param dropdowns are repopulated for the cloned job's modality via
%   fillUserParams / fillParams2Select, because the paramset lists differ between
%   electrophysiology and imaging.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ButtonPushed event (unused)
%
%   Outputs:
%       None - Sets app.jobid_to_copy, app.modality_job_id_copy and
%              app.CreateRecordingOrJob, and switches the GUI to the
%              "Select Parameters" tab in job-only mode
%
%   Dependencies:
%       - fillUserParams, fillParams2Select
%
%   See also: CreateNewJob, jobTableSelected, RerunJob, fillParams2Select

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