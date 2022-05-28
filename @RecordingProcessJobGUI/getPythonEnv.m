function getPythonEnv(app)
%GETPYTHONENV Summary of this function goes here
%   Detailed explanation goes here
[~, conda_envs] = system('conda env list');

idx_py_env = strfind(conda_envs, RecordingProcessJobGUI.py_env_name);
app.py_env = strtrim(conda_envs(idx_py_env(1)+length(RecordingProcessJobGUI.py_env_name):end));

if ispc
    app.py_env = fullfile( app.py_env, 'python');
else
    app.py_env = fullfile( app.py_env, 'bin', 'python');
end

end

