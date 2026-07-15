
function fillParams2Select(app, event_data, modality)
%FILLPARAMS2SELECT Fill the pre-processing and processing paramset dropdowns
%
%   ValueChanged callback for app.UserParamsDropDown, and also called directly to
%   initialize the Select Parameters tab (createRecordingButton, RunJobDiffParams).
%
%   Restricts app.PreProcessParamList and app.ProcessParams to the given modality
%   and, unless the User dropdown reads 'all', to the paramsets authored by the
%   selected user. The surviving pre-processing step-list names
%   (app.preprocess_steps_name_field) go into app.PreprocessingParamsDropDown and
%   the surviving processing paramset descriptions (app.params_desc_field) go into
%   app.ProcessingParamsDropDown. Both field names are modality-independent in
%   configParams ('preprocess_param_steps_name' / 'paramset_desc').
%
%   After refilling, it re-triggers the two selection callbacks so the details
%   panes match the new dropdown contents: ParamSetSelected for the processing
%   paramset and ParamListSelected for the pre-processing list. If the selected
%   user has no paramsets of a kind, the corresponding labels / steps list are
%   blanked instead.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event_data                   - Dropdown ValueChanged event; unused, pass
%                                      [] when calling directly
%       modality (char)              - 'electrophysiology' or 'imaging'.
%                                      Optional; defaults to
%                                      app.Configuration.RecordingModality
%
%   Outputs:
%       None - Sets the Items of app.PreprocessingParamsDropDown and
%              app.ProcessingParamsDropDown, and refreshes the description /
%              user-date labels and the steps list
%
%   Dependencies:
%       - app.PreProcessParamList and app.ProcessParams (filled by fillParams)
%
%   See also: fillUserParams, ParamSetSelected, ParamListSelected, configParams

if nargin < 3
    modality = app.Configuration.RecordingModality;
end

idx_preprocess = app.PreProcessParamList.recording_modality == modality;
idx_process = app.ProcessParams.recording_modality == modality;

if ~strcmp(app.UserParamsDropDown.Value,'all')
    idx_preprocess = idx_preprocess & app.PreProcessParamList.user_params == app.UserParamsDropDown.Value;
    idx_process =    idx_process    & app.ProcessParams.user_params  == app.UserParamsDropDown.Value;
end

preprocess_names = app.PreProcessParamList{idx_preprocess, app.preprocess_steps_name_field};
params_desc = app.ProcessParams{idx_process, app.params_desc_field};

app.PreprocessingParamsDropDown.Items = unique(preprocess_names);
app.ProcessingParamsDropDown.Items = unique(params_desc);

% If the user has no processing parameters
if isempty(app.ProcessingParamsDropDown.Items)
    app.UserDateParamsLabel2.Text = '';
else
    app.ParamSetSelected(app.ProcessingParamsDropDown);
end
    
% If the user has no preprocessing parameters
if isempty(app.PreprocessingParamsDropDown.Items)
    app.PreprocessingParamsStepsList.Items = {};
    app.PreParamsDescriptionLabel2.Text = '';
    app.UserDatePreParamsLabel2.Text = '';
else
    app.ParamListSelected(app.PreprocessingParamsDropDown);
end


end