function [system_call, err_msg] = buildUvScriptCall(uv_exe, script_path, script_args)
%BUILDUVSCRIPTCALL Build a `uv run` command that launches an external python GUI
%
%   Produces
%
%       "<uv>" run --script "<script>" "<arg>" ...
%
%   which runs one of the standalone launchers in PythonScripts/. Each declares
%   its dependencies inline (PEP 723), so uv provisions that tool's environment
%   on demand, on any platform. This replaces open_phy.BAT / open_suite2p.BAT,
%   which shelled out to `conda activate` and so only ever worked on Windows,
%   and only when the user had built the conda envs by hand.
%
%   --script tells uv the path is a PEP 723 script rather than something to
%   resolve against the surrounding project, so the repo's pyproject.toml is
%   ignored even though the launchers live inside the repo. Verified: the
%   command still resolves correctly with a pyproject.toml present whose
%   python floor the GUIs cannot satisfy.
%
%   Inputs:
%       uv_exe      (char/string) - Path to uv, quoted or bare. '' when uv was
%                                   not found, which is reported rather than
%                                   interpolated into a command.
%       script_path (char/string) - The launcher to run
%       script_args (cell)        - Optional. Arguments passed to the launcher
%
%   Outputs:
%       system_call (char) - The command to hand to system(), or '' on bad input
%       err_msg     (char) - Why no command could be built, or '' on success
%
%   See also: OpenExtGUI, OpenExtGUI2, getPythonEnv

system_call = '';
err_msg     = '';

if nargin < 3 || isempty(script_args)
    script_args = {};
end

if ~iscell(script_args)
    script_args = {script_args};
end

if isempty(uv_exe) || ~(ischar(uv_exe) || isstring(uv_exe)) || ...
        strlength(strtrim(string(uv_exe))) == 0
    err_msg = ['uv is not installed, so python tools cannot be launched. ' ...
        'Install it from https://docs.astral.sh/uv/ and restart the app.'];
    return
end

if isempty(script_path) || ~(ischar(script_path) || isstring(script_path)) || ...
        strlength(strtrim(string(script_path))) == 0
    err_msg = 'No launcher script was given.';
    return
end

parts = {quoteIfNeeded(uv_exe), 'run', '--script', quoteIfNeeded(script_path)};

for i = 1:numel(script_args)
    parts{end+1} = quoteIfNeeded(script_args{i}); %#ok<AGROW>
end

system_call = char(strjoin(string(parts)));

end


function out = quoteIfNeeded(value)
%quoteIfNeeded Wrap a value in double quotes when the shell would mangle it.
%
%   MATLAB's system() runs the command through the user's shell, so whitespace
%   is not the only hazard: zsh expands glob characters and aborts the whole
%   command when nothing matches. A data path is far likelier to contain a space
%   than a bracket, but quoting both costs nothing.
%
%   A value that is already wrapped in quotes is left alone, so callers may pass
%   app.py_uv (which getPythonEnv stores pre-quoted) without double-quoting it.

out = char(strtrim(string(value)));

if isempty(out)
    return
end

if startsWith(out, '"') && endsWith(out, '"') && strlength(out) > 1
    return
end

needs_quotes = any(isspace(out)) || any(ismember(out, '[]*?~(){}$&;<>|#'''));

if needs_quotes
    out = ['"' out '"'];
end

end
