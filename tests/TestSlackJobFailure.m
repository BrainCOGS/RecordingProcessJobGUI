classdef TestSlackJobFailure < matlab.unittest.TestCase
%TESTSLACKJOBFAILURE Tests for the Slack report sent when a job upload fails
%
%   When registering a recording, creating a job or rerunning a job fails to
%   reach the DB (or cup), the GUI only told the user at the rig. These cover
%   the message built for Slack, and that reporting never throws on top of the
%   original failure, e.g. when lab.SlackWebhooks cannot be reached.
%
%   See also: buildSlackJobFailureMessage, notifySlackJobFailure

    methods (Test)

        % --- message content ----------------------------------------------

        function messageNamesTheActionAndError(testCase)
            msg = buildSlackJobFailureMessage('Job creation', struct(), 'Duplicate entry');
            testCase.verifySubstring(msg, 'Job creation failed');
            testCase.verifySubstring(msg, 'Duplicate entry');
            testCase.verifySubstring(msg, 'RecordingProcessJobGUI');
        end

        function contextFieldsAreListedInOrder(testCase)
            ctx = struct('system', '185A-Recording', 'job_id', 42);
            msg = buildSlackJobFailureMessage('Job rerun', ctx, 'boom');
            testCase.verifySubstring(msg, 'system: 185A-Recording');
            testCase.verifySubstring(msg, 'job_id: 42');
            testCase.verifyLessThan(strfind(msg, 'system:'), strfind(msg, 'job_id:'));
        end

        function zeroIsReportedNotDropped(testCase)
            % job_id 0 / status 0 are real values, not "missing".
            msg = buildSlackJobFailureMessage('Job rerun', struct('job_id', 0), 'boom');
            testCase.verifySubstring(msg, 'job_id: 0');
        end

        function emptyContextValueIsMarked(testCase)
            msg = buildSlackJobFailureMessage('Job creation', struct('job_id', []), 'boom');
            testCase.verifySubstring(msg, 'job_id: (none)');
        end

        function stringAndLogicalValuesAreFormatted(testCase)
            ctx = struct('modality', "electrophysiology", 'behavior', true);
            msg = buildSlackJobFailureMessage('Recording registration', ctx, 'boom');
            testCase.verifySubstring(msg, 'modality: electrophysiology');
            testCase.verifySubstring(msg, 'behavior: true');
        end

        function cellValueIsFormatted(testCase)
            % app.JobTable.Data{...} cells and fetch() results can be cells.
            ctx = struct('job_id', {{7}});
            msg = buildSlackJobFailureMessage('Job rerun', ctx, 'boom');
            testCase.verifySubstring(msg, 'job_id: 7');
        end

        function emptyContextIsAllowed(testCase)
            msg = buildSlackJobFailureMessage('Job creation', [], 'boom');
            testCase.verifySubstring(msg, 'Job creation failed');
            testCase.verifySubstring(msg, 'boom');
        end

        function missingErrorIsMarked(testCase)
            msg = buildSlackJobFailureMessage('Job creation', struct(), '');
            testCase.verifySubstring(msg, 'Error: (no message)');
        end

        function mexceptionMessageIsUsed(testCase)
            err = MException('dj:insert', 'Cannot add or update a child row');
            msg = buildSlackJobFailureMessage('Job creation', struct(), err);
            testCase.verifySubstring(msg, 'Cannot add or update a child row');
        end

        function slackControlCharactersAreEscaped(testCase)
            % Slack reads <...> as links/mentions and & as an entity.
            msg = buildSlackJobFailureMessage('Job creation', ...
                struct('dir', 'a<b>&c'), 'x < y & <!channel>');
            testCase.verifySubstring(msg, 'a&lt;b&gt;&amp;c');
            testCase.verifySubstring(msg, 'x &lt; y &amp; &lt;!channel&gt;');
            testCase.verifyEmpty(strfind(msg, '<!channel>'));
        end

        function windowsPathIsKeptVerbatim(testCase)
            msg = buildSlackJobFailureMessage('Recording registration', ...
                struct('local_directory', 'D:\NPX_DATA\run_g0'), 'boom');
            testCase.verifySubstring(msg, 'local_directory: D:\NPX_DATA\run_g0');
        end

        % --- sending is best effort -----------------------------------------

        function sendingWithoutDatabaseDoesNotThrow(testCase)
            % No DB (and no lab package) on the test runner: the webhook lookup
            % fails, which must come back as a warning, never as an error that
            % would hide the original failure from the user.
            sent = testCase.verifyWarning( ...
                @() notifySlackJobFailure('Job creation', struct('job_id', 1), 'boom'), ...
                'notifySlackJobFailure:NotSent');
            testCase.verifyFalse(sent);
        end

    end
end
