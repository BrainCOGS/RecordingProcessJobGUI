
function fillParams(app)

%%%%%%%%%%%%%%%%%Fetch parameters from python script (not readable in MATLAB)
if app.py_enabled
    out = system([app.py_env ' ' RecordingProcessJobGUI.py_read_params]);
    if out == 0

        %%%%%%%%%%%%%%%%%%%%Fetch and integrate params matfiles
        params_list      = app.loadParamsFile(RecordingProcessJobGUI.preparams_list_mat);
        params_final     = app.loadParamsFile(RecordingProcessJobGUI.params_mat);
        preparams_final  = app.loadParamsFile(RecordingProcessJobGUI.preparams_mat);

        app.ProcessParams       = struct2table(params_final, 'AsArray', true);
        app.PreProcessParams    = struct2table(preparams_final, 'AsArray', true);
        app.PreProcessParamList = struct2table(params_list, 'AsArray', true);
                
    else
        error('Could not read parameters')
    end
else
    [app.PreProcessParams, app.ProcessParams, app.PreProcessParamList] = app.getParamsFromMatlab(); 
      
end

        
[app.MehodsTable, app.PreMethodsTable] = app.getMethods();

%Split description into (user - date - description)
app.PreProcessParamList = splitDescriptionColumnParams(app, app.PreProcessParamList);
app.ProcessParams = splitDescriptionColumnParams(app, app.ProcessParams);

app.PreProcessParamList = sortrows(app.PreProcessParamList,{'recording_modality',app.preparam_steps_idx_field, 'step_number'});

app.PreProcessParams = convertTable2Categorical(app.PreProcessParams);
app.ProcessParams = convertTable2Categorical(app.ProcessParams);
app.PreProcessParamList = convertTable2Categorical(app.PreProcessParamList);

app.MehodsTable = convertTable2Categorical(app.MehodsTable);
app.PreMethodsTable = convertTable2Categorical(app.PreMethodsTable);


end