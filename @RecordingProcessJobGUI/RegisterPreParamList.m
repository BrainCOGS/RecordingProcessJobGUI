
function RegisterPreParamList(app, event)

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