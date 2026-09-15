function [PreprocessParams, ProcessParams, PreProcessParamList] = getParamsFromMatlab(app)
%GETPARAMSFROMMATLAB Fetch all paramsets straight from the DB, without python
%
%   The fallback path of fillParams, used when app.py_enabled is false (no conda /
%   no EnvAutoPipeGUI env). The normal path runs read_params.py because the
%   paramset 'params' column is a python-pickled blob that MATLAB cannot decode;
%   this function sidesteps that by never reading it - fetch_table_except issues a
%   plain SELECT of every column of the table *except* 'params'. So the paramsets
%   returned here carry their identity (idx, description, method) but not their
%   contents, which is enough to list and select them but not to display them.
%
%   The two modalities are unified onto common column names before being stacked:
%   the ephys tables are renamevars'd from their modality-specific names
%   (clustering_method -> app.param_methods_method_field 'processing_method',
%   precluster_method -> app.preparam_methods_method_field 'preprocess_method',
%   precluster_param_steps_* -> preprocess_param_steps_*) onto the common names
%   held in the flat app properties, which happen to be the imaging names - so the
%   imaging tables need no renaming. Each table then gets a recording_modality
%   column added so downstream code can filter by modality.
%
%   The step list is built by joining PreClusterParamSteps * PreClusterParamStepsStep
%   (the named list and its ordered members) and then joining the pre-processing
%   paramsets onto it, so each row is one step of one named list with that step's
%   paramset metadata attached.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object; supplies the table
%                                      and field-name registries built by configParams
%
%   Outputs:
%       PreprocessParams    - Table of pre-processing paramsets (electrophysiology
%                             only, see note)
%       ProcessParams       - Table of processing paramsets, ephys and imaging
%                             stacked
%       PreProcessParamList - Table of pre-processing step lists, one row per step
%                             (electrophysiology only, see note)
%
%   Note: only the electrophysiology pre-processing tables are read. The imaging
%   pre-processing paramsets and step lists are never fetched, so on a rig with no
%   python an imaging modality has processing paramsets but an empty pre-processing
%   list.
%
%   Dependencies:
%       - fetch_table_except (SELECT all columns but one, via dj.conn)
%       - fetchDataDJTable
%       - DataJoint tables reached through the registries:
%         pipeline_ephys_element.ClusteringParamSet, PreClusterParamSet,
%         PreClusterParamSteps, PreClusterParamStepsStep,
%         pipeline_imaging_element.ProcessingParamSet
%
%   See also: fillParams, configParams, getMethods, getDefaultParamsMod

ephys_params = fetch_table_except(dj.conn, ...
    app.param_table_names.electrophysiology.table_class, 'params');
%Rename vars to "common" param method field
ephys_params = renamevars(ephys_params,...
    app.param_methods_table_names.electrophysiology.method_field,...
    app.param_methods_method_field);

ephys_params.recording_modality = repmat({'electrophysiology'},size(ephys_params,1),1);

imaging_params = fetch_table_except(dj.conn, ...
    app.param_table_names.imaging.table_class, 'params');
imaging_params.recording_modality = repmat({'imaging'},size(imaging_params,1),1);


ephys_preparams = fetch_table_except(dj.conn, ...
    app.preparam_table_names.electrophysiology.table_class, 'params');
%Rename vars to "common" preparam method field
ephys_preparams = renamevars(ephys_preparams,...
    app.preparam_methods_table_names.electrophysiology.method_field,...
    app.preparam_methods_method_field);

ephys_preparams.recording_modality = repmat({'electrophysiology'},size(ephys_preparams,1),1);


ephys_steps = fetchDataDJTable(...
app.preparam_steps_table_names.electrophysiology.table_class() * ...  
app.preparam_steps_step_table_names.electrophysiology.table_class() , ...
    [], {'*'}, "table");
ephys_steps = renamevars(ephys_steps,...
    app.preparam_steps_table_names.electrophysiology.preprocess_steps_idx_field,...
    app.preparam_steps_idx_field);
ephys_steps = renamevars(ephys_steps,...
    app.preparam_steps_table_names.electrophysiology.preprocess_steps_name_field,...
    app.preprocess_steps_name_field);
ephys_steps = renamevars(ephys_steps,...
    app.preparam_steps_table_names.electrophysiology.preprocess_steps_desc_field,...
    app.preprocess_steps_desc_field);
ephys_steps = join(ephys_steps,ephys_preparams);


ProcessParams    = [ephys_params; imaging_params];
PreprocessParams    = [ephys_preparams];
PreProcessParamList = [ephys_steps];

end