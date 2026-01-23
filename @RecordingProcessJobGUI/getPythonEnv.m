function getPythonEnv(app)
%get python environments filepaths

try
    if ismac
        this_path = getenv('PATH');
        this_path = [this_path ':/Users/alvaros/opt/anaconda3/condabin'];
        setenv('PATH', this_path);
    end

        % Get all conda environments and find with specific names
        % (py_env_name, py_iblenv_name)
        [~, conda_envs] = system('conda env list');

        idx_py_env = strfind(conda_envs, RecordingProcessJobGUI.py_env_name);
        
        app.py_env = strtrim(conda_envs(idx_py_env(1)+length(RecordingProcessJobGUI.py_env_name): ...
            idx_py_env(2)+length(RecordingProcessJobGUI.py_env_name)));
        
        if ispc
            app.py_env = fullfile( app.py_env, 'python');
            %Surround with double quotes for filepaths with spaces
            %app.py_env = ['"' app.py_env '"'];
        else
            app.py_env = fullfile( app.py_env, 'bin', 'python');
        end
        
        idx_py_iblenv = strfind(conda_envs, RecordingProcessJobGUI.py_iblenv_name);
        
        app.py_ibl_env = strtrim(conda_envs(idx_py_iblenv(1)+length(RecordingProcessJobGUI.py_env_name): ...
            idx_py_iblenv(2)+length(RecordingProcessJobGUI.py_iblenv_name)));

        if ispc
            app.py_ibl_env = fullfile( app.py_ibl_env, 'python');
        else
            app.py_ibl_env = fullfile( app.py_ibl_env, 'bin', 'python');
        end
        
        %Surround with double quotes for filepaths with spaces
        app.py_ibl_env = ['"' app.py_ibl_env '"'];
        
        
        
        app.py_enabled = true;
catch
    app.py_env = [];
    app.py_enabled = false;

end
