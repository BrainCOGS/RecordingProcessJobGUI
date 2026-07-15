
function fillPreParamsSets(app, event)
%FILLPREPARAMSSETS Fill the Create Parameters tab dropdowns for one modality
%
%   ValueChangedFcn for app.ParamModalityDrop (Create Parameters tab, GridLayoutCP), also
%   called directly with no event by postConfigurationActions, writeParametersDB and
%   RegisterPreParamList to refresh the tab after the configuration or the database
%   changes.
%
%   Modality-aware, and this is the only branch in the function: called as a callback it
%   takes the modality the user just picked in the dropdown (event.Value); called with
%   one argument it falls back to the configured app.Configuration.RecordingModality
%   ('electrophysiology' or 'imaging'). Everything below filters on
%   recording_modality == modality.
%
%   Reads no database directly - it slices the tables fillParams already cached on the
%   app - and fills three dropdowns:
%       app.PreParamsStepsDrop           - existing pre-process steps to add to a step
%                                          list, from app.PreProcessParams rendered as
%                                          '<preprocess_method>: <paramset_desc>'
%       app.CreatePreParamSetMethodsDrop - distinct preprocess_method values available
%                                          for this modality (app.PreProcessParams)
%       app.CreateParamSetMethodsDrop    - distinct processing_method values available
%                                          for this modality (app.ProcessParams)
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The main application object
%       event                        - Optional ValueChanged event from
%                                      app.ParamModalityDrop; only event.Value is used,
%                                      as the modality name. Omit to use
%                                      app.Configuration.RecordingModality
%
%   Outputs:
%       None - Sets app.PreParamsStepsDrop.Items, app.CreatePreParamSetMethodsDrop.Items
%              and app.CreateParamSetMethodsDrop.Items
%
%   Dependencies:
%       - app.PreProcessParams / app.ProcessParams (populated by fillParams)
%
%   See also: fillParams, fillDefaultParams, RegisterPreParamList, postConfigurationActions

if nargin < 2
    modality = app.Configuration.RecordingModality;
else
    modality = event.Value;
end

selected_steplist = app.PreProcessParams{app.PreProcessParams.recording_modality == modality, {'preprocess_method', 'paramset_desc'}};
all_preprocess_methods = unique(selected_steplist(:,1));

selected_steplist = string(selected_steplist);
selected_steplist = [selected_steplist(:,1) repmat(": ",size(selected_steplist,1),1) selected_steplist(:,2)];

selected_steplist2 = strings(size(selected_steplist,1),1);
for i=1:length(selected_steplist2)
    selected_steplist2(i) = strjoin(selected_steplist(i,:));
end

app.PreParamsStepsDrop.Items = unique(selected_steplist2);
%Existing preparams methods
app.CreatePreParamSetMethodsDrop.Items = all_preprocess_methods;


%Existing param methods
sel_params = app.ProcessParams{app.ProcessParams.recording_modality == modality, {'processing_method'}};
app.CreateParamSetMethodsDrop.Items = unique(sel_params);


end