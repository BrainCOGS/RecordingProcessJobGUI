
function fillParams(app, key)

if nargin < 2
    key = [];
end

%%%%%%%%%%%%%%%%%Fetch parameters from python script (not readable in MATLAB)
out = system([RecordingProcessJobGUI.py_env ' ' RecordingProcessJobGUI.py_read_params]);

if out == 0
    
    %%%%%%%%%%%%%%%%%%%%Fetch and integrate params matfiles
    preparams_final = app.loadParamsFile(RecordingProcessJobGUI.preparams_mat);
    params_list = app.loadParamsFile(RecordingProcessJobGUI.preparams_list_mat);
    params_final = app.loadParamsFile(RecordingProcessJobGUI.params_mat);

else
    error('Could not read parameters')
end

app.PreProcessParams = struct2table(preparams_final, 'AsArray', true);
app.ProcessParams = struct2table(params_final, 'AsArray', true);
app.PreProcessParamList = struct2table(params_list, 'AsArray', true);


%app.PreprocessingParamsDropDown.Items = {app.PreProcessParams.paramset_desc};
app.PreprocessingParamsDropDown_2.Items = app.PreProcessParams.paramset_desc;

%app.ProcessingParamsDropDown.Items = {app.ProcessParams.paramset_desc};
app.ProcessingParamsDropDown_2.Items = app.ProcessParams.paramset_desc;

end