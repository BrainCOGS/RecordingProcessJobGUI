function [system_call, err_msg] = buildUvToolCall(uv_exe, tool_name, tool_args)
%BUILDUVTOOLCALL Build a `uv run` command that launches an external python GUI
%
%   Produces
%
%       "<uv>" run --isolated --no-project --python <ver> --with <pkg> ... -- <entry> <args>
%
%   which provisions the tool's environment on demand and runs it, on any
%   platform. This replaces open_phy.BAT / open_suite2p.BAT, which shelled out to
%   `conda activate` and so only ever worked on Windows, and only when the user
%   had built the conda envs by hand.
%
%   --isolated and --no-project are both required: without them uv would pick up
%   the repo's pyproject.toml, whose python >=3.14 requirement these Qt tools
%   cannot satisfy.
%
%   Inputs:
%       uv_exe    (char/string) - Path to the uv executable ('' when unresolved)
%       tool_name (char/string) - A name known to uvToolSpec
%       tool_args (cell)        - Optional. Arguments passed after the -- separator
%
%   Outputs:
%       system_call (char) - The command to hand to system(), or '' on bad input
%       err_msg     (char) - Why no command could be built, or '' on success
%
%   See also: uvToolSpec, OpenExtGUI, OpenExtGUI2, getPythonEnv

system_call = '';
err_msg     = '';

if nargin < 3 || isempty(tool_args)
    tool_args = {};
end

if isempty(uv_exe) || ~(ischar(uv_exe) || isstring(uv_exe)) || strlength(strtrim(string(uv_exe))) == 0
    err_msg = ['uv could not be found or installed, so python tools cannot be ' ...
        'launched. Install it from https://docs.astral.sh/uv/ and restart the app.'];
    return
end

if isempty(tool_name) || ~(ischar(tool_name) || isstring(tool_name))
    err_msg = 'No tool name was given.';
    return
end

spec = uvToolSpec(tool_name);
if isempty(spec)
    err_msg = ['Unknown python tool ''' char(tool_name) '''.'];
    return
end

parts = {quoteIfNeeded(uv_exe), 'run', '--isolated', '--no-project', ...
    '--python', spec.python};

for i = 1:numel(spec.packages)
    parts{end+1} = '--with';                      %#ok<AGROW>
    parts{end+1} = quoteIfNeeded(spec.packages{i}); %#ok<AGROW>
end

parts{end+1} = '--';
parts{end+1} = quoteIfNeeded(spec.entry);

for i = 1:numel(tool_args)
    parts{end+1} = quoteIfNeeded(tool_args{i});   %#ok<AGROW>
end

system_call = char(strjoin(string(parts)));

end


function out = quoteIfNeeded(value)
%quoteIfNeeded Wrap a value in double quotes when the shell would mangle it.
%
%   MATLAB's system() runs the command through the user's shell, so whitespace
%   is not the only hazard: zsh expands glob characters and aborts the whole
%   command on no match, which would break a requirement like suite2p[gui].

out = char(strtrim(string(value)));

if startsWith(out, '"') && endsWith(out, '"') && strlength(out) > 1
    return
end

needs_quotes = any(isspace(out)) || any(ismember(out, '[]*?~(){}$&;<>|#'''));

if needs_quotes
    out = ['"' out '"'];
end

end
