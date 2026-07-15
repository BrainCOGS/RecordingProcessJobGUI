
function fillParams(app)
%FILLPARAMS Load every paramset and pre-process step list into the app's cached tables
%
%   Fills no widget itself. It is the loader that every params-related widget depends on:
%   it populates app.ProcessParams, app.PreProcessParams and app.PreProcessParamList (plus
%   app.MehodsTable / app.PreMethodsTable) once, so fillPreParamsSets, fillDefaultParams
%   and fillParams2Select can slice those tables per modality without hitting the database
%   again. Called from startupFcn and re-called by writeParametersDB /
%   RegisterPreParamList after new params are written.
%
%   Branches on app.py_enabled, not on modality - both paths load both modalities:
%     - Python path (app.py_enabled true): the paramsets are stored as blobs MATLAB
%       cannot unpack, so it shells out to read_params.py under app.py_env
%       (RecordingProcessJobGUI.py_read_params) and reads back the three .mat files it
%       drops in PythonScripts/: preparams_list.mat, params.mat and preparams.mat, via
%       app.loadParamsFile. A nonzero exit status raises 'Could not read parameters'.
%     - MATLAB fallback (app.py_enabled false): app.getParamsFromMatlab() reads the
%       DataJoint element tables directly via fetch_table_except, dropping the 'params'
%       blob column and renaming the modality-specific method / step-index columns to the
%       app's common names.
%
%   Post-processing applied to both paths: app.getMethods() builds the method tables;
%   splitDescriptionColumnParams splits each '*_desc' column into its
%   '<user>_<date>_<description>' parts, adding the user_params and date_params columns
%   that fillDefaultParams later displays; PreProcessParamList is sorted by
%   recording_modality, app.preparam_steps_idx_field ('preprocess_param_steps_id') and
%   step_number so each step list reads in execution order; convertTable2Categorical then
%   turns the text columns categorical, which is what the dropdowns and the
%   'recording_modality == modality' comparisons downstream rely on.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The main application object
%
%   Outputs:
%       None - Sets app.ProcessParams, app.PreProcessParams, app.PreProcessParamList,
%              app.MehodsTable and app.PreMethodsTable
%
%   Dependencies:
%       - PythonScripts/read_params.py (run in the app.py_env conda env), and the
%         params.mat / preparams.mat / preparams_list.mat files it writes
%       - getParamsFromMatlab, getMethods, loadParamsFile, splitDescriptionColumnParams
%       - convertTable2Categorical, fetch_table_except
%       - DataJoint: pipeline_ephys_element.* / pipeline_imaging_element.* paramset and
%         pre-process step tables (reached through app.param_table_names and friends)
%
%   See also: fillPreParamsSets, fillDefaultParams, fillParams2Select, startupFcn

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