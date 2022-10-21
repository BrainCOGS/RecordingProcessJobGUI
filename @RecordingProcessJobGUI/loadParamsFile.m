function param_struct = loadParamsFile(~, param_matfile)
%LOAD_PARAMS_FILE load params matfile (from python script) and transform it to a single struct

params = load(param_matfile);
params_fields = fieldnames(params);

param_struct = params.(params_fields{1});
for i=2:length(params_fields)
    param_struct = [param_struct; params.(params_fields{i})];
end

end

