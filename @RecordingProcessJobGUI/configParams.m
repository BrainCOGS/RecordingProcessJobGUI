function configParams(app)
%CONFIGPARAMS table & field definitions for the GUI

setenv('DB_PREFIX', 'u19_');
connect_tech();

app.params_desc_field = 'paramset_desc';
app.params_idx_field = 'paramset_idx';

%Params table names
app.param_table_names = struct();
app.param_table_names.electrophysiology             = struct();
app.param_table_names.electrophysiology.table_class = pipeline_ephys_element.ClusteringParamSet;

app.param_table_names.imaging             = struct();
app.param_table_names.imaging.table_class = pipeline_imaging_element.ProcessingParamSet;

%Preprocessing table names
app.preparam_table_names = struct();
app.preparam_table_names.electrophysiology             = struct();
app.preparam_table_names.electrophysiology.table_class = pipeline_ephys_element.PreClusterParamSet;

app.preparam_table_names.imaging             = struct();
app.preparam_table_names.imaging.table_class = 'pipeline_imaging_element.PreProcessParamSet';

% To insert Preprocess Steps for different modalities
% Preprocessing Steps Table modalities

app.preparam_steps_idx_field  = 'preprocess_param_steps_id';
app.preprocess_steps_name_field = 'preprocess_param_steps_name';
app.preprocess_steps_desc_field = 'preprocess_param_steps_desc';

app.preparam_steps_table_names = struct();
% Electrophysiology
app.preparam_steps_table_names.electrophysiology = struct();
app.preparam_steps_table_names.electrophysiology.table_class = ...
    pipeline_ephys_element.PreClusterParamSteps;
app.preparam_steps_table_names.electrophysiology.preprocess_steps_idx_field = ...
    'precluster_param_steps_id';
app.preparam_steps_table_names.electrophysiology.preprocess_steps_name_field = ...
    'precluster_param_steps_name';
app.preparam_steps_table_names.electrophysiology.preprocess_steps_desc_field = ...
    'precluster_param_steps_desc';

% Imaging
app.preparam_steps_table_names.imaging           = struct();
app.preparam_steps_table_names.imaging.table_class = ...
    'pipeline_imaging_element.PreProcessParamSteps';
app.preparam_steps_table_names.imaging.preprocess_steps_idx_field = ...
    'preprocess_param_steps_id';
app.preparam_steps_table_names.imaging.preprocess_steps_name_field = ...
    'preprocess_param_steps_name';
app.preparam_steps_table_names.imaging.preprocess_steps_desc_field = ...
    'preprocess_param_steps_desc';

% To insert Preprocess Steps for different modalities
% Preprocessing Step Steps Table modalities
%PreprocessSteps.Step tables:
app.preparam_steps_step_table_names = struct();

app.preparam_steps_step_table_names.electrophysiology = struct();
app.preparam_steps_step_table_names.electrophysiology.table_class = ...
    pipeline_ephys_element.PreClusterParamStepsStep;
app.preparam_steps_step_table_names.electrophysiology.preprocess_steps_idx_field = ...
    'precluster_param_steps_id';
app.preparam_steps_step_table_names.electrophysiology.step_field = ...
    'step_number';
app.preparam_steps_step_table_names.electrophysiology.paramset_idx_field = ...
    'paramset_idx';

app.preparam_steps_step_table_names.imaging           = struct();
app.preparam_steps_step_table_names.imaging.table_class = ...
    'pipeline_imaging_element.PreProcessParamStepsStep';
app.preparam_steps_step_table_names.imaging.preprocess_steps_idx_field = ...
    'preprocess_param_steps_id';
app.preparam_steps_step_table_names.imaging.step_field = ...
    'step_number';
app.preparam_steps_step_table_names.imaging.paramset_idx_field = ...
    'paramset_idx';


app.param_methods_method_field = 'processing_method';
app.param_methods_desc_field   = 'preprocess_method_desc';

%Processing Param Methods table definition
app.param_methods_table_names = struct();
app.param_methods_table_names.electrophysiology              = struct();
app.param_methods_table_names.electrophysiology.table_class  = pipeline_ephys_element.ClusteringMethod;
app.param_methods_table_names.electrophysiology.method_field = 'clustering_method';
app.param_methods_table_names.electrophysiology.desc_field   = 'clustering_method_desc';

app.param_methods_table_names.imaging              = struct();
app.param_methods_table_names.imaging.table_class  = pipeline_imaging_element.ProcessingMethod;
app.param_methods_table_names.imaging.method_field = 'processing_method';
app.param_methods_table_names.imaging.desc_field   = 'processing_method_desc';



%Preprocessing Param Methods table definition

app.preparam_methods_method_field = 'preprocess_method';
app.preparam_methods_desc_field   = 'preprocess_method_desc';

app.preparam_methods_table_names = struct();
app.preparam_methods_table_names.electrophysiology    = struct();
app.preparam_methods_table_names.electrophysiology.table_class = pipeline_ephys_element.PreClusterMethod;
app.preparam_methods_table_names.electrophysiology.method_field = 'precluster_method';
app.preparam_methods_table_names.electrophysiology.desc_field   = 'precluster_method_desc';

%app.preparam_methods_table_names.imaging               = struct();
%app.preparam_methods_table_names.imaging.table_class   = 'pipeline_imaging_element.PreProcessMethod';
%app.preparam_methods_table_names.imaging.method_field  = 'preprocess_method';
%app.preparam_methods_table_names.imaging.desc_field    = 'preprocess_method_desc';

% Status tables
app.recording_history_table_class = recording.LogStatus;
app.job_id_history_table_class = recording_process.LogStatus;

%Initialize variables
app.PreParamSelectionTable  = cell2table(cell(0,2), 'VariableNames', {'fragment_number', app.preparam_steps_idx_field});
app.ParamSelectionTable     = cell2table(cell(0,2), 'VariableNames', {'fragment_number', app.params_idx_field});
app.CreateRecordingOrJob    = true;
app.NewParamJsonFile        = '';
app.NewPreParamJsonFile     = '';


end

