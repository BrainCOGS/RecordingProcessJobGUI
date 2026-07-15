
function RegisterPreParamList(app, event)
%REGISTERPREPARAMLIST Write the assembled ordered pre-processing step list to the DB
%
%   ButtonPushed callback for app.RegisterPreParamListButton ("Register pre param
%   list") on the Create Parameters tab. Turns the listbox
%   app.NewPreParamsListStepsList (built up by AddPreParamStepNewList /
%   MoveStepOrderClicked / DeleteStepClicked) into a named, ordered
%   preprocess_param_steps list and inserts it into the DB. Unlike
%   writeParametersDB this writes through MATLAB DataJoint directly - no python.
%
%   Refuses to run (uiconfirm warning, early return) unless a list name, a list
%   description and at least one step are present.
%
%   Two per-modality tables are written, both resolved from
%   app.ParamModalityDrop.Value:
%     - app.preparam_steps_table_names.(modality).table_class - the list header:
%       PreClusterParamSteps (electrophysiology) / PreprocessParamSteps (imaging).
%       One record with the name, the description and a new index taken as
%       last_id+1 from a "ORDER BY <idx> desc LIMIT 1" fetch1.
%     - app.preparam_steps_step_table_names.(modality).table_class - one row per
%       step: PreClusterParamStepsStep (electrophysiology) /
%       PreprocessParamStepsStep (imaging), keyed by that same steps id, with
%       step_number assigned from the listbox position (1..N) and paramset_idx
%       looked up in app.PreProcessParams by the "<preprocess_method> :
%       <paramset_desc>" text of each entry.
%   The exact field names on each side (preprocess_steps_idx_field,
%   preprocess_steps_name_field, preprocess_steps_desc_field, step_field,
%   paramset_idx_field) also come from those structs, because ephys uses
%   precluster_* names and imaging uses preprocess_* ones - see configParams.
%
%   Both inserts run inside a single dj.conn transaction: on success it commits,
%   reports success, clears the listbox and refreshes the cached params via
%   fillParams / fillPreParamsSets; on any error it calls cancelTransaction so the
%   list header cannot be left in the DB without its steps.
%
%   As with the paramsets, the stored list description is prefixed with the
%   selected user and today's date (app.UserPreparamListDrop.Value '_' yyyy-mm-dd
%   '_' ...), the convention splitDescriptionColumnParams later unpicks.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - Button ButtonPushed event; event.Source is
%                                      re-enabled on failure
%
%   Outputs:
%       None - Inserts one record into the modality's preprocess-steps table and N
%              records into its steps-step table, then clears
%              app.NewPreParamsListStepsList and refreshes the params caches
%
%   Dependencies:
%       - DataJoint: pipeline_ephys_element.PreClusterParamSteps(.Step),
%         pipeline_imaging_element.PreprocessParamSteps(.Step), dj.conn
%       - fillParams, fillPreParamsSets, updateBusyLabel, configParams
%
%   See also: AddPreParamStepNewList, MoveStepOrderClicked, DeleteStepClicked, writeParametersDB

if isempty(app.PreparamListNewNameEdit.Value)
    uiconfirm(app.UIFigure,'Add Pre Param List name',  'Param-list insertion',  'Icon','warning');
    return
end

if isempty(app.PreparamListNewDescEdit.Value)
    uiconfirm(app.UIFigure,'Add Pre Param List description', 'Param-list insertion', 'Icon','warning');
    return
end

if isempty(app.NewPreParamsListStepsList.Items)
    uiconfirm(app.UIFigure, 'Add Steps to Pre Param List', 'Param-list insertion', 'Icon','warning');
    return
    
end

updateBusyLabel(app, false);

%Create PreprocessParamStep Info
this_steps_table = app.preparam_steps_table_names.(app.ParamModalityDrop.Value); 
% Param description include user that defined params & date
paramlist_description = [app.UserPreparamListDrop.Value '_' ...
    datestr(datetime('today'), 'yyyy-mm-dd') '_' ...
    '_' app.PreparamListNewDescEdit.Value];

%Get last id for steps "list" inserted
id_steps_field = this_steps_table.preprocess_steps_idx_field;
last_id = fetch1(this_steps_table.table_class(),id_steps_field, ['ORDER BY ' id_steps_field ' desc LIMIT 1']);


%Create record for the new steps "list"
new_step_record = struct();
new_step_record.(this_steps_table.preprocess_steps_name_field) = app.PreparamListNewNameEdit.Value;
new_step_record.(this_steps_table.preprocess_steps_desc_field) = paramlist_description;
new_step_record.(id_steps_field) = last_id+1;


%Create Step_step table data:
num_steps = length(app.NewPreParamsListStepsList.Items);
%Get field names depending on modality
this_steps_step_table = app.preparam_steps_step_table_names.(app.ParamModalityDrop.Value); 
steps_step_fieldnames = {this_steps_step_table.preprocess_steps_idx_field, ...
                         this_steps_step_table.step_field, ...
                         this_steps_step_table.paramset_idx_field};

table_steps = array2table(nan(num_steps,length(steps_step_fieldnames)), 'VariableNames', steps_step_fieldnames);
% Get idx of params for each step
for i=1:num_steps
    
    values = string(app.NewPreParamsListStepsList.Items(i));
    values = strsplit(values, ": ");
    
    this_preprocess_method = strtrim(values(1));
    this_paramset_desc = strtrim(values(2));
    
    
    paramset_idx = app.PreProcessParams{app.PreProcessParams.preprocess_method == this_preprocess_method & ...
                                        app.PreProcessParams.paramset_desc == this_paramset_desc, app.params_idx_field};
                                            
                                            
    paramset_idx = paramset_idx(1);
    row = [last_id+1 i paramset_idx];
    table_steps{i,:} = row;
end

struct_steps = table2struct(table_steps);

%Insert the corresponding records
conn = dj.conn;
conn.startTransaction()
try
     insert(this_steps_table.table_class(), new_step_record);
     insert(this_steps_step_table.table_class(), struct_steps);
     conn.commitTransaction
    
    uiconfirm(app.UIFigure,'Preprocess Steps were registered successfully', ...
    'Steps Creation Success', ...
    'Options',{'OK'}, ...
    'Icon','success');
    app.NewPreParamsListStepsList.Items = {};
    fillParams(app);
    fillPreParamsSets(app);
    updateBusyLabel(app, true);

catch err
    conn.cancelTransaction
    uiconfirm(app.UIFigure,['Preprocess Steps was not created' err.message], ...
    '', ...
    'Options',{'OK'}, ...
    'Icon','error');
    event.Source.Enable = 'on';
    updateBusyLabel(app, true);

    
end