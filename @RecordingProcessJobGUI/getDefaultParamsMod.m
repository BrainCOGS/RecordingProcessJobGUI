function [default_preparams, default_params] = getDefaultParamsMod(app)
%GETDEFAULTPARAMSMOD Look up the default paramsets for the configured modality
%
%   Answers "what should this rig use if the user does not pick anything?". The
%   defaults are not stored in the GUI or in the config file - they live in the
%   recording.Modality DataJoint table, one row per modality, in the columns
%   default_preprocess_param_steps_id and default_paramset_idx. That table was
%   fetched into app.RecordingModalityTable by startupFcn, so this is a pure
%   in-memory lookup with no DB round-trip.
%
%   It reads the row for app.Configuration.RecordingModality, pulls the two default
%   ids out of it, and uses them to slice the already-loaded paramset tables
%   (app.PreProcessParamList and app.ProcessParams, populated by fillParams),
%   filtering on recording_modality as well as the id. default_preparams comes back
%   as several rows - one per step of the default pre-process step list - while
%   default_params is the single matching paramset row.
%
%   Used by fillDefaultParams (to preselect the Select Parameters tab) and by
%   createDefaultParamsRecord (to attach params to a recording when the user leaves
%   the "use default params" checkbox on).
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object; reads
%                                      app.Configuration.RecordingModality,
%                                      app.RecordingModalityTable,
%                                      app.PreProcessParamList and app.ProcessParams
%
%   Outputs:
%       default_preparams - Rows of app.PreProcessParamList for the modality's
%                           default preprocess_param_steps_id (one row per step)
%       default_params    - Row of app.ProcessParams for the modality's default
%                           paramset_idx
%
%   Dependencies:
%       - recording.Modality (via app.RecordingModalityTable, fetched in startupFcn)
%       - fillParams must have run to populate the paramset tables
%
%   See also: fillDefaultParams, createDefaultParamsRecord, fillParams, startupFcn

modality = app.Configuration.RecordingModality;

this_mod = app.RecordingModalityTable(app.RecordingModalityTable.recording_modality == app.Configuration.RecordingModality, :);

preparam_id = this_mod.default_preprocess_param_steps_id(1);
param_id = this_mod.default_paramset_idx(1);


default_preparams = app.PreProcessParamList(app.PreProcessParamList.recording_modality == modality & ...
    app.PreProcessParamList.preprocess_param_steps_id == preparam_id,:);


default_params = app.ProcessParams(app.ProcessParams.recording_modality == modality & ...
    app.ProcessParams.paramset_idx == param_id, :);


end

