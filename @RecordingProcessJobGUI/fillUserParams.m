
function fillUserParams(app, modality)
%FILLUSERPARAMS Populate the "User" dropdown of the Select Parameters tab
%
%   Collects every distinct paramset author (the 'user_params' column) that has
%   at least one pre-processing step list or one processing paramset for the
%   given modality, and loads them into app.UserParamsDropDown. The dropdown acts
%   as the top-level filter of the tab: fillParams2Select then narrows the
%   pre-processing / processing dropdowns to the picked author.
%
%   The list is sorted alphabetically, then the pseudo-entries 'all' (no
%   filtering) and 'general-user' (the lab-wide paramsets) are forced to the top
%   so they are always the first two choices. 'all' is selected by default.
%
%   The 'user_params' column does not come from the database as such: it is split
%   out of the paramset description string ("<user>_<date>_<desc>") by
%   splitDescriptionColumnParams when fillParams reads the params tables.
%
%   Called with no modality when registering a recording (createRecordingButton),
%   and with the job's modality when re-running a job with different params
%   (RunJobDiffParams), which may differ from the rig's configured modality.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       modality (char)              - 'electrophysiology' or 'imaging'.
%                                      Optional; defaults to
%                                      app.Configuration.RecordingModality
%
%   Outputs:
%       None - Sets app.UserParamsDropDown.Items and .Value ('all')
%
%   Dependencies:
%       - app.PreProcessParamList and app.ProcessParams (filled by fillParams)
%
%   See also: fillParams2Select, fillParams, splitDescriptionColumnParams,
%             RunJobDiffParams

if nargin < 2
    modality = app.Configuration.RecordingModality;
end

user_preprocessing = app.PreProcessParamList{...
        app.PreProcessParamList.recording_modality == modality, 'user_params'};
    
user_proccessing = app.ProcessParams{...
        app.ProcessParams.recording_modality == modality, 'user_params'};
    

all_users = sort(unique([user_preprocessing; user_proccessing]));

%Let's put on top all & general-user
idx_gen = all_users == categorical({'general-user'});
all_users(idx_gen) = [];
all_users = categorical([{'all'; 'general-user'}; all_users]);
    
app.UserParamsDropDown.Items = all_users;
app.UserParamsDropDown.Value = cellstr(all_users(1));

end