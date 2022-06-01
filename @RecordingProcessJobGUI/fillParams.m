
function fillParams(app, key)

if nargin < 2
    key = [];
end

%%%%%%%%%%%%%%%%%Fetch parameters from python script (not readable in MATLAB)
if app.py_enabled
    out = system([app.py_env ' ' RecordingProcessJobGUI.py_read_params]);
    if out == 0

        %%%%%%%%%%%%%%%%%%%%Fetch and integrate params matfiles
        preparams_final = app.loadParamsFile(RecordingProcessJobGUI.preparams_mat);
        params_list = app.loadParamsFile(RecordingProcessJobGUI.preparams_list_mat);
        params_final = app.loadParamsFile(RecordingProcessJobGUI.params_mat);
        
        app.PreProcessParams = struct2table(preparams_final, 'AsArray', true);
        app.ProcessParams = struct2table(params_final, 'AsArray', true);
        app.PreProcessParamList = struct2table(params_list, 'AsArray', true);

    else
        error('Could not read parameters')
    end
else
    [app.PreProcessParams, app.ProcessParams, app.PreProcessParamList] = app.getParamsFromMatlab(); 
      
end

app.PreProcessParamList = sortrows(app.PreProcessParamList,{'recording_modality','preprocessing_param_steps_id', 'step_number'});
    
app.PreProcessParams = convertTable2Categorical(app.PreProcessParams);
app.ProcessParams = convertTable2Categorical(app.ProcessParams);
app.PreProcessParamList = convertTable2Categorical(app.PreProcessParamList);

%app.PreprocessingParamsDropDown.Items = {app.PreProcessParams.paramset_desc};
app.PreprocessingParamsDropDown_2.Items = unique(app.PreProcessParams.paramset_desc);

%app.ProcessingParamsDropDown.Items = {app.ProcessParams.paramset_desc};
app.ProcessingParamsDropDown_2.Items = app.ProcessParams.paramset_desc;

end