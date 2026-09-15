function configParams(app)
%CONFIGPARAMS Register every DataJoint table and field name the GUI uses
%
%   The central name registry for the whole app. It is the very first thing the
%   RecordingProcessJobGUI constructor calls - before createComponents and
%   startupFcn - because it also opens the database connection: it sets the
%   DB_PREFIX environment variable to 'u19_' (which tells the vendored DataJoint
%   schemas which MySQL databases to bind to) and then calls connect_tech() to log
%   in. Nothing DataJoint-related works until this has run.
%
%   The rest of the file exists so that no other method has to hard-code an
%   element-table class or a column name. Electrophysiology and imaging use
%   different DataJoint element tables with different column names for the same
%   concept, so nearly every registry entry is a struct keyed by modality:
%
%       app.<x>_table_names.<modality>.table_class    - the DataJoint table object
%       app.<x>_table_names.<modality>.<field>_field  - that modality's column name
%
%   Callers index it with the live modality string, e.g.
%   app.param_table_names.(app.Configuration.RecordingModality).table_class, and
%   then renamevars the modality-specific column onto the "common" name held in the
%   flat properties alongside each struct (app.params_idx_field,
%   app.param_methods_method_field, app.preparam_steps_idx_field, ...). That
%   rename-to-common trick is what lets getParamsFromMatlab, getMethods and the
%   Create Parameters tab treat both modalities with one code path. Note the common
%   names are simply the imaging names - imaging entries look redundant because the
%   imaging column names were chosen as the canonical ones; ephys is the one that
%   gets renamed.
%
%   The registries, in order:
%     - param_table_names          - processing paramsets (ClusteringParamSet /
%                                    ProcessingParamSet)
%     - preparam_table_names       - pre-processing paramsets (PreClusterParamSet /
%                                    PreProcessParamSet)
%     - preparam_steps_table_names - the named ordered step lists
%                                    (PreClusterParamSteps / PreprocessParamSteps)
%     - preparam_steps_step_table_names - the individual steps of a list, each
%                                    pointing at a step_number and a paramset_idx
%     - param_methods_table_names / preparam_methods_table_names - the method
%                                    vocabularies (kilosort, suite2p, ...)
%     - job_part_parms_table       - per-job params part tables
%                                    (recording_process.ProcessingEphysParams /
%                                    ProcessingImagingParams)
%     - recording_history_table_class / job_id_history_table_class - the status log
%                                    tables shown in the history panes
%
%   It also seeds the empty selection tables (app.ParamSelectionTable,
%   app.PreParamSelectionTable - both keyed by fragment_number), the per-modality
%   raw-file glob patterns in app.AllFileExtensions, and the cup paths. The root
%   directories are not hard-coded: they are read out of lab.DjCustomVariables
%   ('ephys_root_data_dir' / 'imaging_root_data_dir', index 0 = raw ->
%   app.RootDirectories, index 1 = processed -> app.RootProcessedDirectories) and
%   translated to this machine's mount by lab.utils.get_path_from_official_dir.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%
%   Outputs:
%       None - Sets the DB_PREFIX env var, connects to the database, and populates
%              the table/field registry properties on app
%
%   Dependencies:
%       - connect_tech (opens the DataJoint connection)
%       - DataJoint tables: pipeline_ephys_element.* (ClusteringParamSet,
%         PreClusterParamSet, PreClusterParamSteps, PreClusterParamStepsStep,
%         ClusteringMethod, PreClusterMethod), pipeline_imaging_element.*
%         (ProcessingParamSet, PreProcessParamSet, PreprocessParamSteps,
%         PreprocessParamStepsStep, ProcessingMethod, PreprocessMethod),
%         recording_process.ProcessingEphysParams / ProcessingImagingParams,
%         recording.LogStatus, recording_process.LogStatus, lab.DjCustomVariables
%       - lab.utils.get_path_from_official_dir
%
%   See also: RecordingProcessJobGUI, startupFcn, getParamsFromMatlab, getMethods

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
    pipeline_imaging_element.PreprocessParamSteps;
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
    pipeline_imaging_element.PreprocessParamStepsStep;
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

app.preparam_methods_table_names.imaging               = struct();
app.preparam_methods_table_names.imaging.table_class   = pipeline_imaging_element.PreprocessMethod;
app.preparam_methods_table_names.imaging.method_field  = 'preprocess_method';
app.preparam_methods_table_names.imaging.desc_field    = 'preprocess_method_desc';

app.job_part_parms_table = struct(); 

app.job_part_parms_table.electrophysiology = struct();
app.job_part_parms_table.electrophysiology.table_class = recording_process.ProcessingEphysParams; 

app.job_part_parms_table.imaging = struct();
app.job_part_parms_table.imaging.table_class = recording_process.ProcessingImagingParams; 

% Status tables
app.recording_history_table_class = recording.LogStatus;
app.job_id_history_table_class = recording_process.LogStatus;

%Initialize variables
app.PreParamSelectionTable  = cell2table(cell(0,2), 'VariableNames', {'fragment_number', app.preparam_steps_idx_field});
app.ParamSelectionTable     = cell2table(cell(0,2), 'VariableNames', {'fragment_number', app.params_idx_field});
app.CreateRecordingOrJob    = true;
app.selectedRecordingRow    = -1;
app.selectedJobRow          = -1;
app.NewParamJsonFile        = '';
app.NewPreParamJsonFile     = '';

%File extensions:
app.AllFileExtensions = struct;
app.AllFileExtensions.electrophysiology = {'^.*\g0'};
app.AllFileExtensions.imaging = {'^.*\.tiff', '^.*\.tif', '^.*\.avi'};

%DataPaths
[~, app.ProcessedDataPath] = lab.utils.get_path_from_official_dir('braininit/Data/Processed');
app.ErrorLogsPath     = fullfile(app.ProcessedDataPath, 'LOGS', 'ErrorLogs');
app.OutputLogsPath     = fullfile(app.ProcessedDataPath, 'LOGS', 'OutputLogs');

% Root Raw directories
key = struct();
key.custom_variable = 'ephys_root_data_dir';
key.index = 0;
modality_root_dir = fetch1(lab.DjCustomVariables & key, 'value');
[~, modality_root_dir] =  lab.utils.get_path_from_official_dir(modality_root_dir);
app.RootDirectories.electrophysiology = modality_root_dir;

key = struct();
key.custom_variable = 'imaging_root_data_dir';
key.index = 0;
modality_root_dir = fetch1(lab.DjCustomVariables & key, 'value');
[~, modality_root_dir] =  lab.utils.get_path_from_official_dir(modality_root_dir);
app.RootDirectories.imaging = modality_root_dir;

% Root Processed directories
key = struct();
key.custom_variable = 'ephys_root_data_dir';
key.index = 1;
modality_root_dir = fetch1(lab.DjCustomVariables & key, 'value');
[~, modality_root_dir] =  lab.utils.get_path_from_official_dir(modality_root_dir);
app.RootProcessedDirectories.electrophysiology = modality_root_dir;

key = struct();
key.custom_variable = 'imaging_root_data_dir';
key.index = 1;
modality_root_dir = fetch1(lab.DjCustomVariables & key, 'value');
[~, modality_root_dir] =  lab.utils.get_path_from_official_dir(modality_root_dir);
app.RootProcessedDirectories.imaging = modality_root_dir;

app.DefaultImplantationDevice = struct();
app.DefaultImplantationDevice.electrophysiology = 'NeuroPixel_Probe_v1';
app.DefaultImplantationDevice.imaging = 'no_device';

end

