
function [Methods, PreMethods] = getMethods(app)
%GETMETHODS Fetch the available processing and pre-processing methods for every modality
%
%   Builds the two flat method tables the GUI caches in app.MehodsTable and
%   app.PreMethodsTable (see fillParams, which calls this and then converts both to
%   categorical). Loops over the modalities defined in
%   app.param_methods_table_names / app.preparam_methods_table_names - i.e.
%   electrophysiology and imaging - fetching just the method-name column from each
%   modality's method table and stacking the results.
%
%   The two modalities name the same concept differently, so the ephys column is
%   renamed to the common name before stacking: 'clustering_method' ->
%   'processing_method' for Methods, 'precluster_method' -> 'preprocess_method' for
%   PreMethods. A 'recording_modality' column is added to each block so the
%   stacked table stays attributable; fillPreParamsSets restricts on it when
%   filling the method dropdowns.
%
%   Tables involved (via table_class, resolved in configParams):
%     Methods    - pipeline_ephys_element.ClusteringMethod (electrophysiology),
%                  pipeline_imaging_element.ProcessingMethod (imaging)
%     PreMethods - pipeline_ephys_element.PreClusterMethod (electrophysiology),
%                  pipeline_imaging_element.PreprocessMethod (imaging)
%
%   The PreMethods loop skips modalities whose method table comes back empty; the
%   Methods loop has no such guard.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%
%   Outputs:
%       Methods (table)    - One row per processing method, columns
%                            processing_method + recording_modality
%       PreMethods (table) - One row per pre-processing method, columns
%                            preprocess_method + recording_modality
%
%   Dependencies:
%       - fetchDataDJTable (repo-root helper)
%       - DataJoint method tables listed above
%
%   See also: fillParams, fillPreParamsSets, configParams, getParamsFromMatlab

method_modalities = fieldnames(app.param_methods_table_names);

Methods = [];
%Get method table for this modality
for i=1:length(method_modalities)
    this_mod = app.param_methods_table_names.(method_modalities{i});
    this_method_table = fetchDataDJTable(this_mod.table_class(), [], {this_mod.method_field}, "table");
    if ismember("clustering_method", this_method_table.Properties.VariableNames)
        this_method_table = renamevars(this_method_table,"clustering_method","processing_method");
    end
    this_method_table.recording_modality = repmat(method_modalities(i),size(this_method_table,1),1);
    Methods = [Methods; this_method_table];
end

PreMethods = [];
method_modalities = fieldnames(app.preparam_methods_table_names);


%Get method table for this modality
for i=1:length(method_modalities)
    this_mod = app.preparam_methods_table_names.(method_modalities{i});
    this_method_table = fetchDataDJTable(this_mod.table_class(), [], {this_mod.method_field}, "table");
    if ~isempty(this_method_table)
        if ismember("precluster_method", this_method_table.Properties.VariableNames)
            this_method_table = renamevars(this_method_table,"precluster_method","preprocess_method");
        end
        this_method_table.recording_modality = repmat(method_modalities(i),size(this_method_table,1),1);
        PreMethods = [PreMethods; this_method_table];
    end
end
    

end