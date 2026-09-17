classdef TestBuildUvScriptCall < matlab.unittest.TestCase
%TESTBUILDUVSCRIPTCALL Regression tests for buildUvScriptCall
%
%   Covers the two reported crashes and the corner cases around them.
%
%   'Open Phy' on macOS died with
%       zsh:1: permission denied: PythonScripts/open_phy.BAT
%   because the .BAT wrappers are cmd.exe files that MATLAB's system() handed to
%   zsh. 'Open IBL-Atlas' died with
%       Error using string / Conversion from cell failed
%   because app.py_ibl_env was [] and an empty double was interpolated into the
%   command as a cell element. Both are now built here, from a uv path that is
%   checked before anything is assembled.
%
%   See also: buildUvScriptCall, OpenExtGUI, OpenExtGUI2, getPythonEnv

    methods (Test)

        % --- the empty-uv crash -------------------------------------------

        function missingUvIsReportedNotInterpolated(testCase)
            % '' is what getPythonEnv leaves behind when uv is absent.
            [cmd, err] = buildUvScriptCall('', '/s/open_phy.py', {});
            testCase.verifyEmpty(cmd);
            testCase.verifyNotEmpty(err);
            testCase.verifySubstring(err, 'uv is not installed');
        end

        function emptyMatrixUvIsReported(testCase)
            % Regression: app.py_ibl_env was [], not '', and interpolating it
            % is what raised "Conversion from cell failed".
            [cmd, err] = buildUvScriptCall([], '/s/open_ibl_atlas.py', {});
            testCase.verifyEmpty(cmd);
            testCase.verifyNotEmpty(err);
        end

        function whitespaceOnlyUvIsReported(testCase)
            [cmd, err] = buildUvScriptCall('   ', '/s/open_phy.py', {});
            testCase.verifyEmpty(cmd);
            testCase.verifyNotEmpty(err);
        end

        function missingScriptIsReported(testCase)
            [cmd, err] = buildUvScriptCall('/bin/uv', '', {});
            testCase.verifyEmpty(cmd);
            testCase.verifyNotEmpty(err);
        end

        function emptyMatrixScriptIsReported(testCase)
            [cmd, err] = buildUvScriptCall('/bin/uv', [], {});
            testCase.verifyEmpty(cmd);
            testCase.verifyNotEmpty(err);
        end

        % --- command shape -------------------------------------------------

        function commandOptsOutOfTheRepoProject(testCase)
            % The repo project's environment is not the GUIs'; --no-project
            % keeps uv from resolving against pyproject.toml.
            [cmd, err] = buildUvScriptCall('/bin/uv', '/s/open_phy.py', {});
            testCase.verifyEmpty(err);
            testCase.verifySubstring(cmd, '--no-project');
            testCase.verifySubstring(cmd, ' run ');
        end

        function scriptComesBeforeItsArguments(testCase)
            [cmd, ~] = buildUvScriptCall('/bin/uv', '/s/open_ibl_atlas.py', ...
                {'-o','True','-d','/data/ibl_data'});
            script_at = strfind(cmd, 'open_ibl_atlas.py');
            arg_at    = strfind(cmd, '-o');
            testCase.verifyNotEmpty(script_at);
            testCase.verifyNotEmpty(arg_at);
            testCase.verifyLessThan(script_at(1), arg_at(1));
        end

        function argumentsAppearInOrder(testCase)
            [cmd, ~] = buildUvScriptCall('/bin/uv', '/s/x.py', {'-o','True','-d','/p'});
            testCase.verifySubstring(cmd, '-o True -d');
        end

        function resultIsCharNotString(testCase)
            % system() is happiest with a char row vector.
            [cmd, ~] = buildUvScriptCall('/bin/uv', '/s/x.py', {});
            testCase.verifyClass(cmd, 'char');
        end

        % --- quoting -------------------------------------------------------

        function uvPathWithSpacesIsQuoted(testCase)
            [cmd, ~] = buildUvScriptCall('/my tools/uv', '/s/x.py', {});
            testCase.verifySubstring(cmd, '"/my tools/uv"');
        end

        function scriptPathWithSpacesIsQuoted(testCase)
            [cmd, ~] = buildUvScriptCall('/bin/uv', '/my scripts/open_phy.py', {});
            testCase.verifySubstring(cmd, '"/my scripts/open_phy.py"');
        end

        function dataPathWithSpacesStaysOneArgument(testCase)
            % A recording path with a space must not split into two argv entries.
            [cmd, ~] = buildUvScriptCall('/bin/uv', '/s/x.py', {'/my data/ibl_data'});
            testCase.verifySubstring(cmd, '"/my data/ibl_data"');
        end

        function alreadyQuotedUvIsNotDoubleQuoted(testCase)
            % getPythonEnv stores app.py_uv pre-quoted; quoting it again would
            % produce ""/bin/uv"", which the shell reads as an empty command.
            [cmd, ~] = buildUvScriptCall('"/bin/uv"', '/s/x.py', {});
            testCase.verifySubstring(cmd, '"/bin/uv"');
            testCase.verifyFalse(contains(cmd, '""'));
        end

        function windowsPathWithSpacesIsQuoted(testCase)
            [cmd, ~] = buildUvScriptCall('C:\Program Files\uv\uv.exe', '/s/x.py', {});
            testCase.verifySubstring(cmd, '"C:\Program Files\uv\uv.exe"');
        end

        function plainPathIsNotQuoted(testCase)
            % Nothing to escape, so leave it readable.
            [cmd, ~] = buildUvScriptCall('/bin/uv', '/s/x.py', {});
            testCase.verifyFalse(contains(cmd, '"/bin/uv"'));
        end

        function globCharactersAreQuoted(testCase)
            % zsh aborts the whole command on an unmatched glob.
            [cmd, ~] = buildUvScriptCall('/bin/uv', '/s/x.py', {'suite2p[gui]'});
            testCase.verifySubstring(cmd, '"suite2p[gui]"');
        end

        % --- argument handling ---------------------------------------------

        function noArgumentsStillBuilds(testCase)
            [cmd, err] = buildUvScriptCall('/bin/uv', '/s/open_suite2p.py', {});
            testCase.verifyEmpty(err);
            testCase.verifyNotEmpty(cmd);
        end

        function omittedArgsMatchesEmptyCell(testCase)
            a = buildUvScriptCall('/bin/uv', '/s/x.py', {});
            b = buildUvScriptCall('/bin/uv', '/s/x.py');
            testCase.verifyEqual(a, b);
        end

        function bareArgumentIsAcceptedAsIfWrapped(testCase)
            % A lone char arg rather than a 1x1 cell.
            a = buildUvScriptCall('/bin/uv', '/s/x.py', '/data');
            b = buildUvScriptCall('/bin/uv', '/s/x.py', {'/data'});
            testCase.verifyEqual(a, b);
        end

        function stringInputsAreAccepted(testCase)
            [cmd, err] = buildUvScriptCall("/bin/uv", "/s/x.py", {"-d", "/p"});
            testCase.verifyEmpty(err);
            testCase.verifySubstring(cmd, '-d /p');
        end

        % --- the launchers the app actually calls ---------------------------

        function everyLauncherBuilds(testCase)
            launchers = {'open_phy.py', 'open_suite2p.py', 'open_ibl_atlas.py'};
            for i = 1:numel(launchers)
                [cmd, err] = buildUvScriptCall('/bin/uv', ...
                    fullfile('/repo','PythonScripts',launchers{i}), {});
                testCase.verifyEmpty(err, launchers{i});
                testCase.verifySubstring(cmd, launchers{i});
            end
        end

        function noBatWrapperSurvives(testCase)
            % The .BAT files are gone; nothing should reference them.
            [cmd, ~] = buildUvScriptCall('/bin/uv', '/s/open_phy.py', {});
            testCase.verifyFalse(contains(upper(cmd), '.BAT'));
        end

    end

end
