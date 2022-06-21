
function fillPreParamsSets(app, event)

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