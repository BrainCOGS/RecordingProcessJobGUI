
function writeParametersDB(app, event)

if event.Source == app.RegisterParamSetButton
    methodCheckBox = app.NewParamMethodCheckBox;
    methodEdit     = app.NewParamMethodEdit;
    methodDrop     = app.CreateParamSetMethodsDrop;
    descEdit       = app.NewParamSetDescEdit;
    jsonfilevar    = app.NewParamJsonFile;
    type_param     = 'processing';
    method_table   = app.param_methods_table_names.(app.ParamModalityDrop.Value);
      
else
    methodCheckBox = app.NewPreParamMethodCheckBox;
    methodEdit     = app.NewPreParamMethodEdit;
    methodDrop     = app.CreatePreParamSetMethodsDrop;
    descEdit       = app.NewPreParamSetDescEdit;
    jsonfilevar    = app.NewPreParamJsonFile;
    type_param     = 'preprocessing';
    method_table   = app.preparam_methods_table_names.(app.ParamModalityDrop.Value);
end


if methodCheckBox.Value && isempty(methodEdit.Value)
    uiconfirm(app.UIFigure,'Add new processing method',  'Register paramset',  'Icon','warning');
    return
end

if isempty(descEdit.Value)
    uiconfirm(app.UIFigure,'Add Paramset description', 'Register paramset', 'Icon','warning');
    return
end

if isempty(jsonfilevar)
    uiconfirm(app.UIFigure, 'Upload Paramset json file', 'Register paramset', 'Icon','warning');
    return
end

updateBusyLabel(app, false);


% Add method to DB if new method is enabled
if methodCheckBox.Value
    method_struct = struct();
    method_struct.(method_table.method_field) = methodEdit.Value;
    method_struct.(method_table.desc_field)   = '';
    try
        insert(method_table.table_class(), method_struct, 'IGNORE');
    catch err
        uiconfirm(app.UIFigure,['New Method was not registered ' err.message], ...
    '', ...
    'Options',{'OK'}, ...
    'Icon','error');
    updateBusyLabel(app, true);
    return
    end
end
    
% Param description include user that defined params & date
param_description = ['"' app.UserPreparamListDrop.Value '_' ...
    datestr(datetime('today'), 'yyyy-mm-dd') '_' descEdit.Value '"'];

if app.py_enabled
    
    %Create call to python script to upload parameters (ex. call:)
    % python upload_params.py electrophysiology processing /path_to/param.json "param_description" kilosort 
    system_call = [{app.py_env} {RecordingProcessJobGUI.py_upload_params}];
    system_call{end+1} = app.ParamModalityDrop.Value;
    system_call{end+1} = type_param;
    system_call{end+1} = jsonfilevar;
    system_call{end+1} = param_description;
    if methodCheckBox.Value
        system_call{end+1} = methodEdit.Value;
    else
        system_call{end+1} = methodDrop.Value;
    end
    
    %CellArray to char with spaces
    system_call = char(strjoin(string(system_call)));
    
    % Call python script
    [out, cmdout] = system(system_call);
    if out == 0

        uiconfirm(app.UIFigure,'Parameters were registered successfully', ...
        'Parameters Creation Success', ...
        'Options',{'OK'}, ...
        'Icon','success');
    updateBusyLabel(app, true);
    fillParams(app);
    fillPreParamsSets(app);


    else
    uiconfirm(app.UIFigure,['Parameters were not registered ' cmdout], ...
    '', ...
    'Options',{'OK'}, ...
    'Icon','error');
    event.Source.Enable = 'on';
    updateBusyLabel(app, true);

        

    end
    app.UploadPreParamSetFile.BackgroundColor = app.ErrorColor;
    
end