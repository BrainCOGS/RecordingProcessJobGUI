function getPythonEnv(app)
%getPythonEnv Resolve how the app's python helper scripts are invoked.
%
%   app.py_env is a *command prefix*, not an interpreter path. It runs the
%   helper scripts through uv, which resolves/syncs the environment declared in
%   the repo's pyproject.toml on demand:
%
%       "<uv>" run --project "<repo_root>" python
%
%   Consumers (fillParams, writeParametersDB) just interpolate it into a
%   system() call, so a multi-word prefix works the same as a bare path.
%
%   app.py_ibl_env still points at the external IBL conda env, which this repo
%   does not own.

repo_root = fileparts(RecordingProcessJobGUI.gui_path);

uv_exe = findUv();
if isempty(uv_exe)
    uv_exe = installUv();
end

if isempty(uv_exe)
    app.py_env     = [];
    app.py_enabled = false;
    warning('RecordingProcessJobGUI:noUv', ...
        ['Could not find or install uv.\n' ...
         'Install it manually from https://docs.astral.sh/uv/ and restart the app.']);
else
    app.py_env     = ['"' uv_exe '" run --project "' repo_root '" python'];
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

% 1. Already on PATH?
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
    candidates = { ...
        fullfile(home, '.local', 'bin', exe_name), ...
        fullfile('/opt', 'homebrew', 'bin', exe_name), ...
        fullfile('/usr', 'local', 'bin', exe_name), ...
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
