classdef TestBuildRecordingDatetime < matlab.unittest.TestCase
%TESTBUILDRECORDINGDATETIME Regression tests for buildRecordingDatetime
%
%   Registering a recording without a behavior session died with
%       Error using dateformverify
%       DATESTR failed converting date number to date vector.  Date number out of range.
%       Error in datestr (line 204)
%       Error in datetime/datestr (line 867)
%       Error in RecordingProcessJobGUI/createRecording (line 87)
%   because the Recording Date picker was left empty, so its Value was NaT and
%   createRecording handed it straight to datestr. The date and hour are now
%   validated and combined here.
%
%   See also: buildRecordingDatetime, createRecording

    methods (Test)

        % --- the reported crash -------------------------------------------

        function emptyDatePickerIsReportedNotPassedToDatestr(testCase)
            % An untouched uidatepicker's Value is NaT.
            testCase.verifyError(@() buildRecordingDatetime(NaT, 10, 0), ...
                'buildRecordingDatetime:NoDate');
        end

        function emptyDateIsReported(testCase)
            testCase.verifyError(@() buildRecordingDatetime(datetime.empty, 10, 0), ...
                'buildRecordingDatetime:NoDate');
            testCase.verifyError(@() buildRecordingDatetime([], 10, 0), ...
                'buildRecordingDatetime:NoDate');
        end

        % --- hour ------------------------------------------------------------

        function hourIsAddedToTheDate(testCase)
            [rec_dt, session_date] = buildRecordingDatetime(datetime(2026,10,22), 15, 30);
            testCase.verifyEqual(rec_dt, '2026-10-22 15:30:00');
            testCase.verifyEqual(session_date, '20261022_153000');
        end

        function hourZeroIsMidnight(testCase)
            [rec_dt, session_date] = buildRecordingDatetime(datetime(2026,10,22), 0, 0);
            testCase.verifyEqual(rec_dt, '2026-10-22 00:00:00');
            testCase.verifyEqual(session_date, '20261022_000000');
        end

        function timeOfDayOnThePickedDateIsIgnored(testCase)
            % Only the day of the picker counts; the hour comes from the spinner.
            rec_dt = buildRecordingDatetime(datetime(2026,10,22,9,45,0), 15, 0);
            testCase.verifyEqual(rec_dt, '2026-10-22 15:00:00');
        end

        function hourTwentyFourRollsToTheNextDay(testCase)
            % The spinner is labelled 0-24; 24 must not wrap back to the same day.
            [rec_dt, session_date] = buildRecordingDatetime(datetime(2026,10,22), 24, 5);
            testCase.verifyEqual(rec_dt, '2026-10-23 00:05:00');
            testCase.verifyEqual(session_date, '20261023_000500');
        end

        function fractionalMinutesAreDroppedToWholeSeconds(testCase)
            rec_dt = buildRecordingDatetime(datetime(2026,10,22), 1, 59.9999);
            testCase.verifyEqual(rec_dt, '2026-10-22 01:59:59');
        end

        function negativeHourIsReported(testCase)
            testCase.verifyError(@() buildRecordingDatetime(datetime(2026,10,22), -1, 0), ...
                'buildRecordingDatetime:BadHour');
        end

        function hourOverTwentyFourIsReported(testCase)
            testCase.verifyError(@() buildRecordingDatetime(datetime(2026,10,22), 25, 0), ...
                'buildRecordingDatetime:BadHour');
        end

        function nanOrEmptyHourIsReported(testCase)
            testCase.verifyError(@() buildRecordingDatetime(datetime(2026,10,22), NaN, 0), ...
                'buildRecordingDatetime:BadHour');
            testCase.verifyError(@() buildRecordingDatetime(datetime(2026,10,22), [], 0), ...
                'buildRecordingDatetime:BadHour');
        end

    end
end
