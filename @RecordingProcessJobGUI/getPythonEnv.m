function getPythonEnv(app)
%get python environments filepaths

try
    if ismac
        this_path = getenv('PATH');
        home = getenv('HOME');
        this_path = [this_path ':' home '/opt/anaconda3/condabin'];
        this_path = [this_path ':' home '/conda_env_txt/y'];
        this_path = [this_path ':' home '/bin'];
        setenv('PATH', this_path);
    end

        % Get all conda environments and find with specific names
        % (py_env_name, py_iblenv_name)
        [~, conda_envs] = system('conda env list');

        % Split the input string into lines
        lines = strsplit(conda_envs, '\n');

        % Initialize the variable to store the matching path
        matching_path = '';

        % Loop through each line to find the matching environment
        for i = 1:length(lines)
            line = strtrim(lines{i});
            if contains(line, RecordingProcessJobGUI.py_env_name)
                matching_path = strsplit(line, ' ');
                matching_path = matching_path{length(matching_path)};
                break;
            end
        end

        app.py_env = matching_path;

        if ispc
            app.py_env = fullfile( app.py_env, 'python');
            %Surround with double quotes for filepaths with spaces
            %app.py_env = ['"' app.py_env '"'];
        else
            app.py_env = fullfile( app.py_env, 'bin', 'python');
        end

        % Loop through each line to find the matching environment
        for i = 1:length(lines)
            line = strtrim(lines{i});
            if contains(line, RecordingProcessJobGUI.py_iblenv_name)
                matching_path = strsplit(line, ' ');
                matching_path = matching_path{length(matching_path)};
                break;
            end
        end

        app.py_ibl_env = matching_path;

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
