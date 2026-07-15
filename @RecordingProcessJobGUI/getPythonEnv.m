function getPythonEnv(app)
%GETPYTHONENV Locate the conda python interpreters the GUI shells out to
%
%   Called first thing in startupFcn. The app never imports python into MATLAB; it
%   shells out with system(), so all it needs is the absolute path of two
%   interpreters:
%     - app.py_env     - the EnvAutoPipeGUI env (RecordingProcessJobGUI.py_env_name).
%                        Used to run read_params.py and upload_params.py, which
%                        round-trip paramsets through .mat files because the
%                        paramset blobs are pickled and unreadable from MATLAB.
%     - app.py_ibl_env - the iblenv env (RecordingProcessJobGUI.py_iblenv_name).
%                        Used for the IBL ephys atlas GUI and phy.
%
%   It finds them by parsing the text of `conda env list`. Each env's name appears
%   twice per line - once in the name column, once as the tail of its path - so the
%   code takes strfind hits (1) and (2) of the name and slices the text between the
%   end of the first and the end of the second, which yields the env root
%   directory; strtrim removes the column padding. The interpreter is then
%   fullfile'd on as 'python' on Windows or 'bin/python' elsewhere, and py_ibl_env
%   (only) is wrapped in double quotes so paths with spaces survive the system()
%   call. On mac, the anaconda condabin directory is prepended to PATH first so
%   that conda is callable at all.
%
%   The whole body is wrapped in a try/catch: any failure (conda not installed, an
%   env missing so strfind returns fewer than two hits) is swallowed and
%   app.py_enabled is set false. That flag is what makes fillParams fall back to
%   getParamsFromMatlab and what disables the phy / atlas GUI buttons, so a rig
%   without conda still runs.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%
%   Outputs:
%       None - Sets app.py_env, app.py_ibl_env and app.py_enabled
%
%   Dependencies:
%       - conda on the system PATH (`conda env list`)
%       - Constants RecordingProcessJobGUI.py_env_name ('EnvAutoPipeGUI') and
%         RecordingProcessJobGUI.py_iblenv_name ('iblenv')
%
%   See also: startupFcn, fillParams, getParamsFromMatlab

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
        
        app.py_ibl_env = strtrim(conda_envs(idx_py_iblenv(1)+length(RecordingProcessJobGUI.py_iblenv_name): ...
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
    app.py_ibl_env = [];
    app.py_enabled = false;

end
