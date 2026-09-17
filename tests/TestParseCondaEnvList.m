classdef TestParseCondaEnvList < matlab.unittest.TestCase
%TESTPARSECONDAENVLIST Regression tests for parseCondaEnvList
%
%   Covers the second half of the 'Open IBL-Atlas' crash: the iblenv env existed,
%   but `conda` was micromamba, whose `env list` leaves the Name column blank and
%   prints only the path. The old first-column match therefore never fired and
%   app.py_ibl_env stayed [].
%
%   The iblenv / iblenv2 pair on the reporting machine is exactly the prefix
%   collision the lookup must keep rejecting, so it is asserted here too.
%
%   See also: parseCondaEnvList, getPythonEnv, OpenExtGUI2

    properties (Constant)

        CondaOutput = [ ...
            '# conda environments:'                                 newline ...
            '#'                                                     newline ...
            'base                  *  /opt/anaconda3'               newline ...
            'iblenv                   /opt/anaconda3/envs/iblenv'   newline ...
            'iblenv2                  /opt/anaconda3/envs/iblenv2'  newline]

        MicromambaOutput = [ ...
            '  Name  Active  Path'                                   newline ...
            '-------------------------------------------'            newline ...
            '                /home/u/y/envs/dj'                      newline ...
            '                /home/u/y/envs/iblenv'                  newline ...
            '                /home/u/y/envs/iblenv2'                 newline ...
            '  base          /home/u/micromamba'                     newline]

    end

    methods (Test)

        function condaFormatIsParsed(testCase)
            d = parseCondaEnvList(testCase.CondaOutput, 'iblenv');
            testCase.verifyEqual(d, '/opt/anaconda3/envs/iblenv');
        end

        function micromambaFormatIsParsed(testCase)
            % Regression: blank Name column used to make this return ''.
            d = parseCondaEnvList(testCase.MicromambaOutput, 'iblenv');
            testCase.verifyEqual(d, '/home/u/y/envs/iblenv');
        end

        function prefixNameIsNotMatchedInCondaFormat(testCase)
            % iblenv must never resolve to iblenv2, or vice versa.
            d = parseCondaEnvList(testCase.CondaOutput, 'iblenv2');
            testCase.verifyEqual(d, '/opt/anaconda3/envs/iblenv2');
        end

        function prefixNameIsNotMatchedInMicromambaFormat(testCase)
            d = parseCondaEnvList(testCase.MicromambaOutput, 'iblenv2');
            testCase.verifyEqual(d, '/home/u/y/envs/iblenv2');
        end

        function baseRowIsMatchedByName(testCase)
            % base is the one row micromamba does fill the Name column for.
            d = parseCondaEnvList(testCase.MicromambaOutput, 'base');
            testCase.verifyEqual(d, '/home/u/micromamba');
        end

        function activeMarkerDoesNotBecomeThePath(testCase)
            % The '*' column must not be mistaken for the env directory.
            d = parseCondaEnvList(testCase.CondaOutput, 'base');
            testCase.verifyEqual(d, '/opt/anaconda3');
        end

        function unknownEnvReturnsEmpty(testCase)
            d = parseCondaEnvList(testCase.CondaOutput, 'nope');
            testCase.verifyEmpty(d);
        end

        function emptyOutputReturnsEmpty(testCase)
            testCase.verifyEmpty(parseCondaEnvList('', 'iblenv'));
        end

        function commentsAndBlanksAreIgnored(testCase)
            only_noise = ['# conda environments:' newline '#' newline newline];
            testCase.verifyEmpty(parseCondaEnvList(only_noise, 'iblenv'));
        end

        function headerRowIsNotMatchedAsAnEnv(testCase)
            % 'Name' and 'Path' are header words, not env names.
            testCase.verifyEmpty(parseCondaEnvList(testCase.MicromambaOutput, 'Name'));
            testCase.verifyEmpty(parseCondaEnvList(testCase.MicromambaOutput, 'Path'));
        end

        function carriageReturnsAreTolerated(testCase)
            % Windows line endings arriving through system().
            crlf = strrep(testCase.CondaOutput, newline, [char(13) newline]);
            d = parseCondaEnvList(crlf, 'iblenv');
            testCase.verifyEqual(d, '/opt/anaconda3/envs/iblenv');
        end

        function pathWithSpacesIsKeptWhole(testCase)
            out = ['# conda environments:' newline ...
                   'iblenv    /Users/me/my envs/iblenv' newline];
            d = parseCondaEnvList(out, 'iblenv');
            testCase.verifyEqual(d, '/Users/me/my envs/iblenv');
        end

        function micromambaPathWithSpacesIsKeptWhole(testCase)
            out = ['  Name  Active  Path' newline ...
                   '                /Users/me/my envs/iblenv' newline];
            d = parseCondaEnvList(out, 'iblenv');
            testCase.verifyEqual(d, '/Users/me/my envs/iblenv');
        end

    end

end
