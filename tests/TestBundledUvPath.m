classdef TestBundledUvPath < matlab.unittest.TestCase
%TESTBUNDLEDUVPATH Tests for bundledUvPath, the uv shipped inside the compiled app
%
%   The Windows release bundles the latest uv.exe under <repo_root>/bin so a
%   rig with no uv (and no internet, or a policy that blocks Astral's
%   installer) can still run the python tools. getPythonEnv falls back to it
%   after a locally installed uv and before trying installUv.
%
%   See also: bundledUvPath, getPythonEnv

    properties
        Root
    end

    methods (TestMethodSetup)
        function makeRoot(testCase)
            testCase.Root = tempname;
            mkdir(testCase.Root);
            testCase.addTeardown(@() rmdir(testCase.Root, 's'));
        end
    end

    methods (Static)
        function name = exeName()
            if ispc; name = 'uv.exe'; else; name = 'uv'; end
        end

        function touch(file)
            fid = fopen(file, 'w');
            fclose(fid);
        end
    end

    methods (Test)

        function findsBundledUv(testCase)
            mkdir(fullfile(testCase.Root, 'bin'));
            expected = fullfile(testCase.Root, 'bin', TestBundledUvPath.exeName());
            TestBundledUvPath.touch(expected);
            testCase.verifyEqual(bundledUvPath(testCase.Root), expected);
        end

        function acceptsStringRoot(testCase)
            mkdir(fullfile(testCase.Root, 'bin'));
            expected = fullfile(testCase.Root, 'bin', TestBundledUvPath.exeName());
            TestBundledUvPath.touch(expected);
            testCase.verifyEqual(bundledUvPath(string(testCase.Root)), expected);
        end

        function emptyWhenNoBinDir(testCase)
            testCase.verifyEqual(bundledUvPath(testCase.Root), '');
        end

        function emptyWhenBinDirHasNoUv(testCase)
            mkdir(fullfile(testCase.Root, 'bin'));
            testCase.verifyEqual(bundledUvPath(testCase.Root), '');
        end

        function ignoresDirectoryNamedLikeUv(testCase)
            % Only a file counts; a folder called uv(.exe) is not runnable.
            mkdir(fullfile(testCase.Root, 'bin', TestBundledUvPath.exeName()));
            testCase.verifyEqual(bundledUvPath(testCase.Root), '');
        end

        function emptyForEmptyRoot(testCase)
            testCase.verifyEqual(bundledUvPath(''), '');
            testCase.verifyEqual(bundledUvPath([]), '');
            testCase.verifyEqual(bundledUvPath(""), '');
        end

        function emptyForMissingRoot(testCase)
            testCase.verifyEqual(bundledUvPath(fullfile(testCase.Root, 'nope')), '');
        end

    end
end
