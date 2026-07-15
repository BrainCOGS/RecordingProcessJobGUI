
function writeParametersDB(app, event)
%WRITEPARAMETERSDB Register a new processing or pre-processing paramset in the DB
%
%   Shared ButtonPushed callback for app.RegisterParamSetButton ("Register Proc.
%   Param Set") and app.RegisterPreParamSetButton ("Register Preproc. Param Set")
%   on the Create Parameters tab. event.Source is compared against
%   app.RegisterParamSetButton to pick, in one go, every processing-vs-preprocessing
%   control it needs: the new-method checkbox/edit, the existing-method dropdown,
%   the description edit, the staged json path set by UploadParamJsonFile
%   (app.NewParamJsonFile / app.NewPreParamJsonFile), the type_param string
%   ('processing' / 'preprocessing') and the methods table.
%
%   Refuses to run (uiconfirm warning, early return) unless a method name, a
%   paramset description and an uploaded json file are all present.
%
%   Two different write paths are involved, which is worth being clear about:
%     - The *method* row, when the "define new method" checkbox is ticked, is
%       inserted from MATLAB via DataJoint, with 'IGNORE' so re-registering an
%       existing method is harmless. The table and its field names come from
%       app.param_methods_table_names.(modality) (ClusteringMethod for ephys,
%       ProcessingMethod for imaging) or app.preparam_methods_table_names.(modality)
%       (PreClusterMethod for ephys, PreprocessMethod for imaging), keyed off
%       app.ParamModalityDrop.Value. The method description is inserted empty ('').
%     - The *paramset* itself is NOT inserted from MATLAB. It is delegated to the
%       python script upload_params.py, shelled out through app.py_env, e.g.
%           python upload_params.py electrophysiology processing /path/param.json "desc" kilosort
%       upload_params.py maps (modality, type) onto the real paramset table
%       (PreClusterParamSet / ClusteringParamSet for ephys, PreProcessParamSet /
%       ProcessingParamSet for imaging), assigns paramset_idx as last_id+1,
%       computes param_set_hash and refuses to re-insert a hash-identical paramset
%       under a different idx.
%
%   The stored paramset description is prefixed with the selected user and today's
%   date ('"' user '_' yyyy-mm-dd '_' desc '"'), the convention
%   splitDescriptionColumnParams later unpicks; the surrounding double quotes keep
%   it one shell argument. On a zero exit code it reports success and refreshes the
%   cached params via fillParams / fillPreParamsSets; otherwise it shows cmdout in
%   an error dialog and re-enables the source button.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - Button ButtonPushed event; event.Source
%                                      selects processing vs pre-processing
%
%   Outputs:
%       None - Inserts the paramset (via upload_params.py) and optionally a new
%              method row, then refreshes the params caches
%
%   Dependencies:
%       - PythonScripts/upload_params.py (RecordingProcessJobGUI.py_upload_params),
%         run in the app.py_env conda environment
%       - DataJoint method tables: pipeline_ephys_element.ClusteringMethod /
%         PreClusterMethod, pipeline_imaging_element.ProcessingMethod /
%         PreprocessMethod
%       - fillParams, fillPreParamsSets, updateBusyLabel, configParams
%
%   See also: UploadParamJsonFile, RegisterPreParamList, checkBoxParamMethod, checkBoxPreParamMethod

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