function varargout = uvToolSpec(tool_name)
%UVTOOLSPEC The uv-managed environment for each external python GUI
%
%   One place describing how to build the environment for each python tool the
%   app shells out to. Called with no arguments it returns the list of known tool
%   names; called with a name it returns that tool's spec struct:
%
%       python   - the interpreter version uv should provision
%       packages - the --with dependency set
%       entry    - the executable uv should run
%
%   These tools cannot live in the repo's own uv project: pyproject.toml requires
%   python >=3.14 (for datajoint and the params helpers), while phy, ibllib and
%   suite2p are all 3.10-era Qt applications. Each therefore gets an isolated,
%   uv-provisioned environment instead of the conda env the .BAT wrappers used to
%   activate.
%
%   Inputs:
%       tool_name (char/string) - Optional. The tool to describe
%
%   Outputs:
%       names (cell)   - When called with no arguments: the known tool names
%       spec  (struct) - When called with a name: that tool's spec, or [] if
%                        the name is unknown
%
%   See also: buildUvToolCall, getPythonEnv, OpenExtGUI, OpenExtGUI2

specs = struct( ...
    'phy', struct( ...
        'python',   '3.10', ...
        'packages', {{'phy'}}, ...
        'entry',    'phy'), ...
    'suite2p', struct( ...
        'python',   '3.10', ...
        'packages', {{'suite2p[gui]'}}, ...
        'entry',    'suite2p'), ...
    'ibl_atlas', struct( ...
        'python',   '3.10', ...
        ... PyQt5 is deliberately unpinned. iblapps' requirements.txt asks for
        ... 5.12.3, which publishes no Apple Silicon wheel; the environments
        ... where this GUI actually runs today resolve to 5.15.x.
        'packages', {{'ibllib', 'easyqc', 'pyqtgraph', 'simpleITK', 'PyQt5'}}, ...
        'entry',    'python'));

if nargin < 1
    varargout{1} = fieldnames(specs);
    return
end

name = char(tool_name);
if isvarname(name) && isfield(specs, name)
    varargout{1} = specs.(name);
else
    varargout{1} = [];
end

end
