function getPythonEnv(app)
%GETPYTHONENV Resolve how the GUI shells out to python
%
%   Called first thing in startupFcn. The app never imports python into MATLAB; it
%   shells out with system(), so all it needs is a few strings it can interpolate
%   into a command line:
%     - app.py_env     - a *command prefix*, not an interpreter path. It runs the
%                        helper scripts through uv, which resolves/syncs the
%                        environment declared in the repo's pyproject.toml on
%                        demand:
%
%                            "<uv>" run --project "<repo_root>" python
%
%                        Used to run read_params.py and upload_params.py, which
%                        round-trip paramsets through .mat files because the
%                        paramset blobs are pickled and unreadable from MATLAB.
%                        Consumers (fillParams, writeParametersDB) just
%                        interpolate it into a system() call, so a multi-word
%                        prefix works the same as a bare path.
%     - app.py_uv      - the quoted uv executable on its own, for standalone
%                        scripts that declare their own dependencies inline (PEP
%                        723) rather than sharing the repo environment:
%
%                            "<uv>" run --no-project <script> <args>
%
%                        Used for open_phy.py and open_suite2p.py, whose Qt stacks
%                        cannot coexist with the helper-script environment.
%     - app.py_ibl_env - the interpreter of the iblenv conda env
%                        (RecordingProcessJobGUI.py_iblenv_name), which this repo
%                        does not own. Used for the IBL ephys atlas GUI only; phy
%                        no longer needs conda. Wrapped in double quotes so paths
%                        with spaces survive the system() call.
%
%   uv is located with findUv (PATH first, then the standard per-user install
%   dirs, since MATLAB's system() inherits a minimal PATH) and, failing that,
%   bootstrapped with installUv via Astral's official installer. If uv still
%   cannot be found, app.py_enabled is set false. That flag is what makes
%   fillParams fall back to getParamsFromMatlab and what disables the phy / atlas
%   GUI buttons, so a rig without a working python setup still runs.
%
%   The iblenv interpreter is looked up by getCondaEnvPython, which matches the
%   env name against the Name column of `conda env list` and returns [] on any
%   failure (conda not installed, env missing) without affecting app.py_enabled.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%
%   Outputs:
%       None - Sets app.py_env, app.py_uv, app.py_ibl_env and app.py_enabled
%
%   Dependencies:
%       - uv (https://docs.astral.sh/uv/), installed on demand if absent
%       - pyproject.toml at the repo root declaring the helper-script env
%       - conda on the system PATH (`conda env list`) for py_ibl_env only
%       - Constant RecordingProcessJobGUI.py_iblenv_name ('iblenv')
%
%   See also: startupFcn, fillParams, getParamsFromMatlab

repo_root = fileparts(RecordingProcessJobGUI.gui_path);

uv_exe = findUv();
if isempty(uv_exe)
    uv_exe = installUv();
end

if isempty(uv_exe)
    app.py_env     = [];
    app.py_uv      = [];
    app.py_enabled = false;
    warning('RecordingProcessJobGUI:noUv', ...
        ['Could not find or install uv.\n' ...
         'Install it manually from https://docs.astral.sh/uv/ and restart the app.']);
else
    app.py_env     = ['"' uv_exe '" run --project "' repo_root '" python'];
    app.py_uv      = ['"' uv_exe '"'];
    app.py_enabled = true;
end

% The IBL atlas GUI still lives in a separate conda environment.
app.py_ibl_env = getCondaEnvPython(RecordingProcessJobGUI.py_iblenv_name);

end


function uv_exe = findUv()
%findUv Locate the uv executable, checking PATH then the standard install dirs.

uv_exe = '';

if ispc
    exe_name = 'uv.exe';
    which_cmd = 'where uv';
else
    exe_name = 'uv';
    which_cmd = 'command -v uv';
end

% 1. Already on PATH? MATLAB's system() inherits a minimal PATH, so on unix ask
%    a login shell, which sources the user's profile and sees the real PATH.
if ~ispc
    [status, out] = system(['$SHELL -l -c ''' which_cmd ''' 2>/dev/null']);
    if status == 0
        lines = strsplit(strtrim(out), newline);
        candidate = strtrim(lines{end});
        if ~isempty(candidate) && isfile(candidate)
            uv_exe = candidate;
            return
        end
    end
end

[status, out] = system(which_cmd);
if status == 0
    lines = strsplit(strtrim(out), newline);
    candidate = strtrim(lines{1});
    if ~isempty(candidate) && isfile(candidate)
        uv_exe = candidate;
        return
    end
end

% 2. Standard install locations. MATLAB's system() inherits a minimal PATH that
%    typically omits ~/.local/bin and Homebrew, so check them explicitly.
home = char(java.lang.System.getProperty('user.home'));
if ispc
    candidates = { ...
        fullfile(home, '.local', 'bin', exe_name), ...
        fullfile(home, 'AppData', 'Local', 'Programs', 'uv', exe_name), ...
        fullfile(home, 'AppData', 'Roaming', 'uv', 'bin', exe_name)};
else
    % macOS and linux. Astral's installer prefers ~/.local/bin; the rest cover
    % homebrew (both arm64 and intel prefixes), linuxbrew, distro packages and
    % old cargo installs.
    candidates = { ...
        fullfile(home, '.local', 'bin', exe_name), ...
        fullfile('/opt', 'homebrew', 'bin', exe_name), ...
        fullfile('/usr', 'local', 'bin', exe_name), ...
        fullfile('/home', 'linuxbrew', '.linuxbrew', 'bin', exe_name), ...
        fullfile('/usr', 'bin', exe_name), ...
        fullfile('/snap', 'bin', exe_name), ...
        fullfile(home, '.cargo', 'bin', exe_name)};
end

for i = 1:numel(candidates)
    if isfile(candidates{i})
        uv_exe = candidates{i};
        return
    end
end

end


function uv_exe = installUv()
%installUv Bootstrap uv using Astral's official installer, then re-locate it.

uv_exe = '';

if ispc
    install_cmd = ['powershell -ExecutionPolicy ByPass ' ...
                   '-c "irm https://astral.sh/uv/install.ps1 | iex"'];
else
    install_cmd = 'curl -LsSf https://astral.sh/uv/install.sh | sh';
end

fprintf('uv not found. Installing it from https://astral.sh/uv ...\n');
[status, out] = system(install_cmd);
if status ~= 0
    fprintf(2, 'uv install failed:\n%s\n', out);
    return
end

uv_exe = findUv();

end


function py_path = getCondaEnvPython(env_name)
%getCondaEnvPython Look up a conda env's interpreter by name.
%
%   Matches env_name against the leading Name column of `conda env list`, rather
%   than assuming the name occurs exactly twice in the raw output (which breaks
%   on names that are prefixes of others, e.g. iblenv vs iblenv2).

py_path = [];

try
    [status, conda_envs] = system('conda env list');
    if status ~= 0
        return
    end

    lines = strsplit(conda_envs, newline);
    for i = 1:numel(lines)
        this_line = strtrim(lines{i});
        if isempty(this_line) || startsWith(this_line, '#')
            continue
        end

        tokens = strsplit(this_line);
        tokens = tokens(~cellfun(@isempty, tokens));
        if numel(tokens) < 2 || ~strcmp(tokens{1}, env_name)
            continue
        end

        env_dir = tokens{end};
        if ispc
            candidate = fullfile(env_dir, 'python.exe');
        else
            candidate = fullfile(env_dir, 'bin', 'python');
        end
        if isfile(candidate)
            py_path = ['"' candidate '"'];
        end
        return
    end
catch
    py_path = [];
end

end
