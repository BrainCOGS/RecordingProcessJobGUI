function env_dir = parseCondaEnvList(list_output, env_name)
%PARSECONDAENVLIST Find an environment's directory in `conda env list` output
%
%   Handles the two table shapes this command produces:
%
%     conda:      "iblenv                   /opt/anaconda3/envs/iblenv"
%     micromamba: "                /home/u/y/envs/iblenv"
%
%   micromamba prints a Name/Active/Path table and leaves the Name column blank
%   for every env except base, so matching on the first token alone (as this
%   lookup originally did) silently found nothing and left app.py_ibl_env empty.
%   A row whose Name column is blank is therefore matched on the basename of its
%   path instead.
%
%   Matching is exact in both cases, never a prefix: an env named iblenv must not
%   resolve to iblenv2.
%
%   Inputs:
%       list_output (char/string) - Raw stdout of `conda env list`
%       env_name    (char/string) - The environment name to look up
%
%   Outputs:
%       env_dir (char) - The environment's directory, or '' when not found
%
%   See also: getPythonEnv, OpenExtGUI2

env_dir = '';

if isempty(list_output) || isempty(env_name)
    return
end

wanted = char(env_name);
lines  = strsplit(char(list_output), newline);

for i = 1:numel(lines)
    this_line = strtrim(strrep(lines{i}, char(13), ''));

    if isempty(this_line) || startsWith(this_line, '#')
        continue
    end

    % The path is the trailing absolute path; everything before it is the Name
    % and Active columns. Capturing it this way keeps paths containing spaces
    % intact, which splitting on whitespace would not.
    token = regexp(this_line, '(?:^|\s)([/\\]|[A-Za-z]:[/\\]).*$', 'match', 'once');
    if isempty(token)
        continue
    end

    this_path = strtrim(token);
    name_col  = strtrim(this_line(1:end-numel(token)));

    % Strip the Active column marker so it is never read as the name.
    name_col = strtrim(strrep(name_col, '*', ''));

    if isempty(name_col)
        % micromamba: name not printed, so fall back to the directory name.
        [~, this_name] = fileparts(this_path);
    else
        this_name = name_col;
    end

    if strcmp(this_name, wanted)
        env_dir = this_path;
        return
    end
end

end
