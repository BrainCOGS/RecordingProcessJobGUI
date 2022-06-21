function [default_preparams, default_params] = getDefaultParamsMod(app)
%GETDEFAULTPARAMSMOD

modality = app.Configuration.RecordingModality;

this_mod = app.RecordingModalityTable(app.RecordingModalityTable.recording_modality == app.Configuration.RecordingModality, :);

preparam_id = this_mod.default_preprocess_param_steps_id(1);
param_id = this_mod.default_paramset_idx(1);


default_preparams = app.PreProcessParamList(app.PreProcessParamList.recording_modality == modality & ...
    app.PreProcessParamList.preprocess_param_steps_id == preparam_id,:);


default_params = app.ProcessParams(app.ProcessParams.recording_modality == modality & ...
    app.ProcessParams.paramset_idx == param_id, :);


end

