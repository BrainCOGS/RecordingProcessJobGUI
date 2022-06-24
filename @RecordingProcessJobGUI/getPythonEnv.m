function getPythonEnv(app)
%GETPYTHONENV Summary of this function goes here
%   Detailed explanation goes here

try
    if ismac
        this_path = getenv('PATH');
        this_path = [this_path ':/Users/alvaros/opt/anaconda3/condabin'];
        setenv('PATH', this_path);
    end

        [~, conda_envs] = system('conda env list');

        idx_py_env = strfind(conda_envs, RecordingProcessJobGUI.py_env_name);
        
        app.py_env = strtrim(conda_envs(idx_py_env(1)+length(RecordingProcessJobGUI.py_env_name): ...
            idx_py_env(2)+length(RecordingProcessJobGUI.py_env_name)));

        if ispc
            app.py_env = fullfile( app.py_env, 'python');
        else
            app.py_env = fullfile( app.py_env, 'bin', 'python');
        end
        app.py_enabled = true;
catch
    app.py_env = [];
    app.py_enabled = false;

end
