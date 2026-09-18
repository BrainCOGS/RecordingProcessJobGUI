classdef TestOutputDirMatch < matlab.unittest.TestCase
%TESTOUTPUTDIRMATCH Regression tests for OpenExtGUI's output-directory match
%
%   Clicking 'Open Suite2p-GUI' on an imaging job reported
%       Error while opening Phy. Cannot find sorting directory
%   because the directory filter required 'kil' in the name for every
%   modality. Ephys sorters write kilosort4_output, but imaging writes
%   suite2p_output, so the imaging branch never matched anything and the
%   button could not work on any imaging job.
%
%   These assert the pattern OpenExtGUI uses. Kept in step with the `if
%   this_modality == "imaging"` block there.
%
%   See also: OpenExtGUI

    methods (Static)
        function out = match(modality, dir_info)
            if modality == "imaging"
                idx = contains(dir_info, 'suite2p') & contains(dir_info, '_output');
            else
                idx = contains(dir_info, 'kil') & contains(dir_info, '_output');
            end
            hits = dir_info(idx);
            if isempty(hits); out = ''; else; out = hits{1}; end
        end
    end

    methods (Test)

        function imagingFindsSuite2pOutput(testCase)
            % The reported bug: this used to return '' and fail the button.
            d = {'.','..','suite2p_output'};
            testCase.verifyEqual(TestOutputDirMatch.match("imaging", d), 'suite2p_output');
        end

        function imagingIgnoresOtherOutputDirs(testCase)
            d = {'.','..','registration_output','suite2p_output'};
            testCase.verifyEqual(TestOutputDirMatch.match("imaging", d), 'suite2p_output');
        end

        function ephysStillFindsKilosort4(testCase)
            d = {'.','..','kilosort4_output'};
            testCase.verifyEqual(TestOutputDirMatch.match("electrophysiology", d), 'kilosort4_output');
        end

        function ephysStillFindsKilosort2_5(testCase)
            % Version numbers vary, hence the 'kil' substring rather than a pin.
            d = {'.','..','kilosort2_5_output'};
            testCase.verifyEqual(TestOutputDirMatch.match("electrophysiology", d), 'kilosort2_5_output');
        end

        function ephysIgnoresCatgtOutput(testCase)
            % catgt is a pre-processing step, not the sorter output.
            d = {'.','..','catgt_output','kilosort4_output'};
            testCase.verifyEqual(TestOutputDirMatch.match("electrophysiology", d), 'kilosort4_output');
        end

        function ephysDoesNotMatchSuite2p(testCase)
            % An imaging dir under an ephys job must not be picked up.
            d = {'.','..','suite2p_output'};
            testCase.verifyEmpty(TestOutputDirMatch.match("electrophysiology", d));
        end

        function imagingDoesNotMatchKilosort(testCase)
            d = {'.','..','kilosort4_output'};
            testCase.verifyEmpty(TestOutputDirMatch.match("imaging", d));
        end

        function missingOutputDirReturnsEmpty(testCase)
            d = {'.','..','logs'};
            testCase.verifyEmpty(TestOutputDirMatch.match("imaging", d));
            testCase.verifyEmpty(TestOutputDirMatch.match("electrophysiology", d));
        end

        function emptyListingReturnsEmpty(testCase)
            testCase.verifyEmpty(TestOutputDirMatch.match("imaging", {}));
        end

        function bareDotEntriesOnly(testCase)
            % dir() always yields '.' and '..'; neither may match.
            testCase.verifyEmpty(TestOutputDirMatch.match("imaging", {'.','..'}));
        end

    end

end
