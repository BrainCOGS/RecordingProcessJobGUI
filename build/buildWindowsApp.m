function results = buildWindowsApp(opts)
%BUILDWINDOWSAPP Compile the GUI into a standalone Windows app and its installer
%
%   Scripted replacement for building Recording_Automation_GUI.prj by hand. It
%   is what .github/workflows/windows-release.yml runs, and it runs the same way
%   on a Windows machine with MATLAB Compiler:
%
%       addpath build
%       buildWindowsApp(U19Root="C:\Experiments\U19-pipeline-matlab")
%
%   Two things come out of OutputDir:
%       app/        Recording_Automation_GUI.exe, for machines that already have
%                   the matching MATLAB Runtime
%       installer/  Recording_Automation_GUI_Installer.exe, which downloads and
%                   installs the free MATLAB Runtime if it is missing, then the
%                   app. Neither needs a MATLAB license to run.
%
%   The app is packaged with everything the .prj bundled: the repo's own code
%   and helper toolboxes, mym, the python scripts together with the
%   pyproject.toml/uv.lock that read_params.py runs against, and the DataJoint
%   schemas from U19-pipeline-matlab. If <repo>/bin/uv.exe exists (the workflow
%   downloads the latest release there) it is bundled too; see bundledUvPath.
%
%   Name-value options:
%       U19Root   - checkout of BrainCOGS/U19-pipeline-matlab (required)
%       OutputDir - where to write app/ and installer/ (default <repo>/dist)
%       Version   - version stamped on the exe and installer, up to four
%                   dot-separated numbers (default '1.7')
%
%   See also: bundledUvPath, compiler.build.standaloneWindowsApplication,
%             compiler.package.installer

arguments
    opts.U19Root   (1,1) string
    opts.OutputDir (1,1) string = ""
    opts.Version   (1,1) string = "1.7"
end

app_name = 'Recording_Automation_GUI';
repo = fileparts(fileparts(mfilename('fullpath')));
u19 = char(opts.U19Root);
out_dir = char(opts.OutputDir);
if isempty(out_dir)
    out_dir = fullfile(repo, 'dist');
end

assert(isfolder(fullfile(u19, 'schemas')), ...
    'buildWindowsApp:noU19', 'U19Root has no schemas folder: %s', u19);

% Repo contents, mirroring fileset.resources/depfun in the .prj. Dependency
% analysis finds the plain .m helpers on its own, but data files and anything
% resolved by name at runtime (images, JSON, python, mym's DLLs, DataJoint's
% which('<schema>.getSchema')) has to be listed.
repo_files = { ...
    '@RecordingProcessJobGUI', 'compareVersions', 'dirwalk', 'GHToolbox', ...
    'modDataJoint', 'mym-mariadbconn', 'PythonScripts', ...
    'system_conf_job_gui.json', 'pyproject.toml', 'uv.lock', ...
    'connect_tech.p', 'brain_cogs_on_white_small_brain_cogs_on_white.png', ...
    'reload.png', 'OneDrive_Folder_Icon.svg.png'};
root_m = dir(fullfile(repo, '*.m'));
repo_files = [repo_files, {root_m.name}];
if isfolder(fullfile(repo, 'bin'))
    repo_files{end+1} = 'bin';
else
    warning('buildWindowsApp:noUv', ...
        'No bin/ folder; the app will rely on a uv installed on each machine.');
end
additional = fullfile(repo, repo_files);

u19_m = dir(fullfile(u19, '*.m'));
additional = [additional, ...
    {fullfile(u19, 'schemas'), fullfile(u19, 'utils')}, ...
    fullfile(u19, {u19_m.name})];

missing = additional(~cellfun(@(p) isfile(p) || isfolder(p), additional));
assert(isempty(missing), 'buildWindowsApp:missing', ...
    'Missing build inputs:\n  %s', strjoin(missing, '\n  '));

% The Compiler functions take image icons, not the .prj's icon.ico.
icon = fullfile(repo, 'Recording_Automation_GUI_resources', 'icon_48.png');
splash = fullfile(repo, 'brain_cogs_on_white_small_brain_cogs_on_white.png');

results = compiler.build.standaloneWindowsApplication( ...
    fullfile(repo, '@RecordingProcessJobGUI', 'RecordingProcessJobGUI.m'), ...
    'ExecutableName', app_name, ...
    'ExecutableIcon', icon, ...
    'ExecutableSplashScreen', splash, ...
    'ExecutableVersion', exeVersion(opts.Version), ...
    'AdditionalFiles', additional, ...
    'OutputDir', fullfile(out_dir, 'app'), ...
    'Verbose', 'on');

compiler.package.installer(results, ...
    'ApplicationName', app_name, ...
    'AuthorName', 'Alvaro Luna & Christian Tabedzki', ...
    'AuthorCompany', 'Princeton', ...
    'Summary', 'GUI to register recordings in the automatic pipeline', ...
    'Version', char(opts.Version), ...
    'InstallerName', [app_name '_Installer'], ...
    'InstallerIcon', icon, ...
    'InstallerLogo', splash, ...
    'InstallerSplash', splash, ...
    'DefaultInstallationDir', ['C:\Program Files\Princeton\' app_name], ...
    'RuntimeDelivery', 'web', ...
    'OutputDir', fullfile(out_dir, 'installer'), ...
    'Verbose', 'on');

fprintf('Built %s %s into %s\n', app_name, opts.Version, out_dir);

end


function v = exeVersion(version)
%exeVersion Pad a version like 1.7.42 to the four fields the exe resource wants.

parts = split(version, '.');
assert(numel(parts) <= 4 && all(~isnan(str2double(parts))), ...
    'buildWindowsApp:badVersion', 'Version must be up to four numbers: %s', version);
parts(end+1:4) = "0";
v = char(join(parts, '.'));

end
