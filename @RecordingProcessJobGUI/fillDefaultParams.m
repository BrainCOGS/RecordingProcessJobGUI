
function fillDefaultParams(app)
%FILLDEFAULTPARAMS Show this rig's default pre-process and process params
%
%   Fills the two read-only summary uitables on the Add Recording tab (GridLayout2) that
%   tell the user which paramsets a new recording will be processed with if they do not
%   override anything:
%       app.DefaultPreParamTable.Data - the default pre-process step list, columns
%                                       app.COLUMNS_DEF_PREPARAMS_TABLE
%                                       (preprocess_param_steps_name,
%                                       preprocess_param_steps_desc, step_number,
%                                       preprocess_method, paramset_desc, user_params,
%                                       date_params) - one row per step, in order
%       app.DefaultParamTable.Data    - the default processing paramset, columns
%                                       app.COLUMNS_DEF_PARAMS_TABLE (paramset_desc,
%                                       processing_method, user_params, date_params)
%   Both are converted cell-by-cell to string for display.
%
%   Modality-aware, but the branch lives in getDefaultParamsMod, which does the work:
%   it looks up app.Configuration.RecordingModality ('electrophysiology' or 'imaging')
%   in app.RecordingModalityTable to read that modality's
%   default_preprocess_param_steps_id and default_paramset_idx, then selects the matching
%   rows out of the cached app.PreProcessParamList and app.ProcessParams. The user_params
%   and date_params columns exist only because fillParams ran
%   splitDescriptionColumnParams first, so fillParams must have been called before this.
%
%   Called by postConfigurationActions, i.e. whenever the configuration is (re)applied
%   and the modality may have changed.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The main application object
%
%   Outputs:
%       None - Sets app.DefaultPreParamTable.Data and app.DefaultParamTable.Data
%
%   Dependencies:
%       - getDefaultParamsMod
%       - app.PreProcessParamList / app.ProcessParams / app.RecordingModalityTable
%         (populated by fillParams and startupFcn)
%
%   See also: getDefaultParamsMod, fillParams, fillPreParamsSets, postConfigurationActions

[default_preparams, default_params] = getDefaultParamsMod(app);

default_preparams = default_preparams(:, app.COLUMNS_DEF_PREPARAMS_TABLE);
app.DefaultPreParamTable.Data = cellfun(@string, table2cell(default_preparams));

default_params = default_params(:, app.COLUMNS_DEF_PARAMS_TABLE);
app.DefaultParamTable.Data = cellfun(@string, table2cell(default_params));


end