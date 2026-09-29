function conf_file = resolveConfFile(bundled_file, user_dir)
%RESOLVECONFFILE Pick the system configuration file the GUI reads and writes
%
%   From source (user_dir empty) this is the checkout's own
%   system_conf_job_gui.json, as it always was.
%
%   The compiled app runs out of the MATLAB Runtime's extraction cache, which
%   is keyed by build, so anything written next to the code is gone after the
%   next update. When deployed, checkConfiguration passes a per-user folder
%   instead: the configuration lives there, seeded from the bundled file the
%   first time and never overwritten after that.
%
%   Inputs:
%       bundled_file (char|string) - the configuration shipped with the code
%       user_dir     (char|string) - persistent folder for the rig's copy, or
%                                    empty to use bundled_file directly
%
%   Outputs:
%       conf_file (char) - the file to load and save. When deployed and there is
%                          nothing to seed from, this path does not exist yet and
%                          the caller reports the missing file.
%
%   See also: checkConfiguration, configureSystem

bundled_file = char(bundled_file);

if isempty(user_dir) || strlength(string(user_dir)) == 0
    conf_file = bundled_file;
    return
end

user_dir = char(user_dir);
[~, name, ext] = fileparts(bundled_file);
conf_file = fullfile(user_dir, [name ext]);

if ~isfile(conf_file) && isfile(bundled_file)
    if ~isfolder(user_dir)
        mkdir(user_dir);
    end
    copyfile(bundled_file, conf_file);
    % Files extracted from the app archive can be read-only; configureSystem
    % has to be able to save over the copy.
    fileattrib(conf_file, '+w');
end

end
