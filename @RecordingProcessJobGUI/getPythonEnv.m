function getPythonEnv(app)
%get python environments filepaths

try
    if ispc
        [out, cmdout] = system("echo %USERPROFILE%");
        app.envs_dir = fullfile(cmdout(1:end-1), 'EnvsAutoPipeGUI');
        sufix_python_env = fullfile('.venv', 'Scripts', 'python');
        sufix_python_env_act = fullfile('.venv', 'Scripts', 'activate');

    elseif ismac
        [out, cmdout] = system("echo %HOME");
        app.envs_dir = fullfile(cmdout(1:end-1), 'EnvsAutoPipeGUI');
        sufix_python_env = fullfile('.venv', 'bin', 'python');
        sufix_python_env_act = fullfile('.venv', 'bin', 'activate');
    end

        app.envs_struct.py_env = ['"' fullfile(app.envs_dir, app.py_env_name, sufix_python_env) '"'];
        app.envs_struct.py_env_act = ['"' fullfile(app.envs_dir, app.py_env_name, sufix_python_env_act) '"'];

        app.envs_struct.phy_env = ['"' fullfile(app.envs_dir, app.phy_env_name, sufix_python_env) '"'];
        app.envs_struct.phy_env_act = ['"' fullfile(app.envs_dir, app.phy_env_name, sufix_python_env_act) '"'];

        app.envs_struct.suite2p_env = ['"' fullfile(app.envs_dir, app.suite2p_env_name, sufix_python_env) '"'];
        app.envs_struct.suite2p_env_act = ['"' fullfile(app.envs_dir, app.suite2p_env_name, sufix_python_env_act) '"'];

        app.envs_struct.ibl_env = ['"' fullfile(app.envs_dir, app.ibl_env_name, sufix_python_env)  '"'];
        app.envs_struct.ibl_env_act = ['"' fullfile(app.envs_dir, app.ibl_env_name, sufix_python_env_act)  '"'];
        
        
        %Surround with double quotes for filepaths with spaces
        %app.py_ibl_env = ['"' app.py_ibl_env '"'];
        
        
        app.py_enabled = true;
catch
    app.envs_struct = [];
    app.py_enabled = false;

end
