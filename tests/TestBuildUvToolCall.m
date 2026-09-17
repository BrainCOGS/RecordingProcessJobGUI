classdef TestBuildUvToolCall < matlab.unittest.TestCase
%TESTBUILDUVTOOLCALL Tests for buildUvToolCall
%
%   buildUvToolCall replaces the conda-activate .BAT wrappers (open_phy.BAT,
%   open_suite2p.BAT), which only ever ran on Windows, with a `uv run` command
%   that builds the tool's environment on demand on any platform.
%
%   The tools cannot share the repo's own uv project: pyproject.toml requires
%   python >=3.14, while phy / ibllib / suite2p need 3.10. Each tool therefore
%   gets --isolated --no-project plus its own --python and --with set.
%
%   See also: buildUvToolCall, uvToolSpec, OpenExtGUI, OpenExtGUI2

    methods (Test)

        function missingUvIsReported(testCase)
            % uv is absent when findUv/installUv both failed at startup.
            [cmd, err] = buildUvToolCall('', 'phy', {});
            testCase.verifyEmpty(cmd);
            testCase.verifyNotEmpty(err);
        end

        function emptyUvMatrixIsReported(testCase)
            [cmd, err] = buildUvToolCall([], 'phy', {});
            testCase.verifyEmpty(cmd);
            testCase.verifyNotEmpty(err);
        end

        function unknownToolIsReported(testCase)
            [cmd, err] = buildUvToolCall('/bin/uv', 'not_a_tool', {});
            testCase.verifyEmpty(cmd);
            testCase.verifyNotEmpty(err);
        end

        function phyCommandIsIsolatedFromTheRepoProject(testCase)
            % The repo project pins python>=3.14, which phy cannot run on, so
            % the call must opt out of it explicitly.
            [cmd, err] = buildUvToolCall('/bin/uv', 'phy', {'template-gui','params.py'});
            testCase.verifyEmpty(err);
            testCase.verifySubstring(cmd, '--isolated');
            testCase.verifySubstring(cmd, '--no-project');
            testCase.verifySubstring(cmd, '--python 3.10');
            testCase.verifySubstring(cmd, '--with phy');
        end

        function phyUsesPortableParamsFilename(testCase)
            % open_phy.BAT hardcoded win_params.py; phy writes params.py.
            [cmd, ~] = buildUvToolCall('/bin/uv', 'phy', {'template-gui','params.py'});
            testCase.verifySubstring(cmd, 'params.py');
            testCase.verifyFalse(contains(cmd, 'win_params'));
        end

        function argumentsArePassedAfterTheSeparator(testCase)
            % Everything after -- belongs to the tool, not to uv.
            [cmd, ~] = buildUvToolCall('/bin/uv', 'phy', {'template-gui','params.py'});
            sep = strfind(cmd, ' -- ');
            testCase.verifyNotEmpty(sep);
            tail = cmd(sep(1):end);
            testCase.verifySubstring(tail, 'template-gui');
            testCase.verifySubstring(tail, 'params.py');
        end

        function suite2pIsSupported(testCase)
            [cmd, err] = buildUvToolCall('/bin/uv', 'suite2p', {});
            testCase.verifyEmpty(err);
            testCase.verifySubstring(cmd, 'suite2p');
        end

        function iblAtlasPullsTheWholeStack(testCase)
            [cmd, err] = buildUvToolCall('/bin/uv', 'ibl_atlas', {'-o','True'});
            testCase.verifyEmpty(err);
            testCase.verifySubstring(cmd, 'ibllib');
            testCase.verifySubstring(cmd, 'easyqc');
            testCase.verifySubstring(cmd, 'pyqtgraph');
        end

        function iblAtlasDoesNotPinTheUnbuildablePyQt(testCase)
            % iblapps requirements.txt pins PyQt5==5.12.3, which has no wheels
            % for Apple Silicon. The working iblenv runs 5.15.11.
            [cmd, ~] = buildUvToolCall('/bin/uv', 'ibl_atlas', {});
            testCase.verifyFalse(contains(cmd, '5.12.3'));
        end

        function extrasBracketsAreQuoted(testCase)
            % MATLAB's system() runs through the user's shell; zsh treats
            % suite2p[gui] as a glob and fails with "no matches found" unless
            % the argument is quoted.
            [cmd, ~] = buildUvToolCall('/bin/uv', 'suite2p', {});
            testCase.verifySubstring(cmd, '"suite2p[gui]"');
        end

        function noBareGlobCharactersSurviveInAnyToolCall(testCase)
            names = uvToolSpec();
            for i = 1:numel(names)
                [cmd, ~] = buildUvToolCall('/bin/uv', names{i}, {});
                % Any [ or ] present must sit inside a quoted run.
                bare = regexp(cmd, '(?<!")\S*\[[^"]*\]\S*(?!")', 'match');
                unquoted = bare(~startsWith(bare, '"'));
                testCase.verifyEmpty(unquoted, names{i});
            end
        end

        function uvPathWithSpacesIsQuoted(testCase)
            [cmd, ~] = buildUvToolCall('/my tools/uv', 'phy', {});
            testCase.verifySubstring(cmd, '"/my tools/uv"');
        end

        function argumentsWithSpacesAreQuoted(testCase)
            % A data path with a space must stay one argv entry.
            [cmd, ~] = buildUvToolCall('/bin/uv', 'ibl_atlas', {'-d','/my data/ibl_data'});
            testCase.verifySubstring(cmd, '"/my data/ibl_data"');
        end

        function noArgumentsStillBuilds(testCase)
            [cmd, err] = buildUvToolCall('/bin/uv', 'suite2p', {});
            testCase.verifyEmpty(err);
            testCase.verifyClass(cmd, 'char');
        end

        function emptyArgsCellAndOmittedArgsAgree(testCase)
            a = buildUvToolCall('/bin/uv', 'suite2p', {});
            b = buildUvToolCall('/bin/uv', 'suite2p');
            testCase.verifyEqual(a, b);
        end

        function stringToolNameIsAccepted(testCase)
            [cmd, err] = buildUvToolCall('/bin/uv', "phy", {});
            testCase.verifyEmpty(err);
            testCase.verifyNotEmpty(cmd);
        end

        function everyKnownToolBuilds(testCase)
            % uvToolSpec and this builder must not drift apart.
            names = uvToolSpec();
            testCase.verifyNotEmpty(names);
            for i = 1:numel(names)
                [cmd, err] = buildUvToolCall('/bin/uv', names{i}, {});
                testCase.verifyEmpty(err, names{i});
                testCase.verifyNotEmpty(cmd, names{i});
            end
        end

    end

end
