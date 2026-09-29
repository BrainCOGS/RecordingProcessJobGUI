classdef TestResolveConfFile < matlab.unittest.TestCase
%TESTRESOLVECONFFILE Tests for resolveConfFile, where the rig configuration lives
%
%   The compiled app runs out of the MATLAB Runtime's extraction cache, which
%   is keyed by build, so a configuration saved next to the code was lost on
%   every update and the rig had to be configured again. When deployed the
%   file now lives in a per-user folder, seeded once from the bundled copy.
%
%   See also: resolveConfFile, checkConfiguration

    properties
        Root
        Bundled
        UserDir
    end

    methods (TestMethodSetup)
        function makeDirs(testCase)
            testCase.Root = tempname;
            mkdir(testCase.Root);
            testCase.addTeardown(@() rmdir(testCase.Root, 's'));
            testCase.Bundled = fullfile(testCase.Root, 'bundled', 'system_conf_job_gui.json');
            mkdir(fileparts(testCase.Bundled));
            TestResolveConfFile.write(testCase.Bundled, '{"System":"bundled"}');
            testCase.UserDir = fullfile(testCase.Root, 'user', 'RecordingProcessJobGUI');
        end
    end

    methods (Static)
        function write(file, text)
            fid = fopen(file, 'w');
            fprintf(fid, '%s', text);
            fclose(fid);
        end
    end

    methods (Test)

        function noUserDirUsesBundledFile(testCase)
            % Running from source: edit the checkout's file, as before.
            testCase.verifyEqual(resolveConfFile(testCase.Bundled, ''), testCase.Bundled);
            testCase.verifyEqual(resolveConfFile(testCase.Bundled, []), testCase.Bundled);
            testCase.verifyEqual(resolveConfFile(testCase.Bundled, ""), testCase.Bundled);
        end

        function seedsUserCopyOnFirstRun(testCase)
            out = resolveConfFile(testCase.Bundled, testCase.UserDir);
            testCase.verifyEqual(out, fullfile(testCase.UserDir, 'system_conf_job_gui.json'));
            testCase.verifyTrue(isfile(out));
            testCase.verifyEqual(fileread(out), '{"System":"bundled"}');
        end

        function keepsExistingUserCopy(testCase)
            % The regression: an update must not overwrite the rig's config.
            mkdir(testCase.UserDir);
            user_file = fullfile(testCase.UserDir, 'system_conf_job_gui.json');
            TestResolveConfFile.write(user_file, '{"System":"rig"}');
            out = resolveConfFile(testCase.Bundled, testCase.UserDir);
            testCase.verifyEqual(out, user_file);
            testCase.verifyEqual(fileread(out), '{"System":"rig"}');
        end

        function missingBundledStillReturnsUserPath(testCase)
            % Nothing to seed from; checkConfiguration reports the missing file.
            delete(testCase.Bundled);
            out = resolveConfFile(testCase.Bundled, testCase.UserDir);
            testCase.verifyEqual(out, fullfile(testCase.UserDir, 'system_conf_job_gui.json'));
            testCase.verifyFalse(isfile(out));
        end

        function acceptsStringInputs(testCase)
            out = resolveConfFile(string(testCase.Bundled), string(testCase.UserDir));
            testCase.verifyClass(out, 'char');
            testCase.verifyTrue(isfile(out));
        end

    end
end
