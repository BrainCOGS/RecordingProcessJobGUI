function uv_exe = bundledUvPath(repo_root)
%BUNDLEDUVPATH Path to the uv executable shipped with the app, or '' if there is none
%
%   The Windows release workflow downloads the latest uv and packages it at
%   <repo_root>/bin/uv.exe, so the compiled app can run its python tools on a
%   rig where uv was never installed. A source checkout normally has no bin/
%   folder and gets ''.
%
%   Inputs:
%       repo_root (char|string) - folder holding the app's code, i.e.
%                                 fileparts(RecordingProcessJobGUI.gui_path)
%
%   Outputs:
%       uv_exe (char) - full path to the bundled uv, or '' when it is absent
%
%   See also: getPythonEnv

uv_exe = '';

if isempty(repo_root) || strlength(string(repo_root)) == 0
    return
end

if ispc
    exe_name = 'uv.exe';
else
    exe_name = 'uv';
end

candidate = fullfile(char(repo_root), 'bin', exe_name);
if isfile(candidate)
    uv_exe = candidate;
end

end
