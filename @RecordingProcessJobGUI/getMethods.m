
function [Methods, PreMethods] = getMethods(app)

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