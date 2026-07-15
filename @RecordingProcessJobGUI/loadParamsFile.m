function param_struct = loadParamsFile(~, param_matfile)
%LOADPARAMSFILE Load a params .mat written by read_params.py into a single struct array
%
%   Bridges the python -> MATLAB hand-off for paramsets. PythonScripts/read_params.py
%   fetches the paramset tables over DataJoint and savemat's them with one variable
%   per record, named 'param_0', 'param_1', ... - a shape MATLAB cannot use
%   directly. This loads such a file and concatenates every variable in it into one
%   struct array, one element per paramset record, which fillParams then turns into
%   a table with struct2table(..., 'AsArray', true).
%
%   Called by fillParams for the three files read_params.py writes, all constants on
%   the class: RecordingProcessJobGUI.params_mat (processing paramsets),
%   .preparams_mat (pre-processing paramsets) and .preparams_list_mat (the
%   pre-processing steps lists, joined with their paramsets), which land in
%   app.ProcessParams, app.PreProcessParams and app.PreProcessParamList.
%   Concatenation relies on every record in a given file having identical fields;
%   read_params.py normalises the modality-specific names (clustering_method ->
%   processing_method, precluster_* -> preprocess_*) and stringifies param_set_hash
%   to make that true.
%
%   The app object is accepted but unused (~), so this is effectively a static
%   helper reached as app.loadParamsFile(...).
%
%   Inputs:
%       ~                     - The GUI application object (unused)
%       param_matfile (char)  - Full path to the .mat file written by read_params.py
%
%   Outputs:
%       param_struct (struct) - Struct array with one element per paramset record
%
%   Dependencies:
%       - PythonScripts/read_params.py (writes params.mat / preparams.mat /
%         preparams_list.mat)
%
%   See also: fillParams, getParamsFromMatlab, splitDescriptionColumnParams

params = load(param_matfile);
params_fields = fieldnames(params);

param_struct = params.(params_fields{1});
for i=2:length(params_fields)
    param_struct = [param_struct; params.(params_fields{i})];
end

end

