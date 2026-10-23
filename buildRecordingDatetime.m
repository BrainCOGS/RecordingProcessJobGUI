function [recording_datetime, session_date] = buildRecordingDatetime(rec_date, rec_hour, rec_minutes)
%BUILDRECORDINGDATETIME Combine the Recording Date picker and hour spinner into a datetime
%
%   For a recording without a behavior session, createRecording takes the day
%   from app.RecordingDateDatePicker and the hour from app.RecordingDateTimePicker
%   (a uispinner labelled 0-24), plus a random number of minutes so the key is
%   unique. This validates both before formatting: an untouched date picker
%   holds NaT, which datestr rejects with "Date number out of range".
%
%   Inputs:
%       rec_date    (datetime) - The picked day; any time of day on it is ignored
%       rec_hour    (double)   - Hour, 0 to 24. 24 rolls over to the next day.
%       rec_minutes (double)   - Minutes to add, truncated to whole seconds
%
%   Outputs:
%       recording_datetime (char) - 'yyyy-mm-dd HH:MM:SS', for the DB key
%       session_date       (char) - 'yyyymmdd_HHMMSS', for the cup path
%
%   Errors:
%       buildRecordingDatetime:NoDate  - rec_date is empty or NaT
%       buildRecordingDatetime:BadHour - rec_hour is empty, NaN or outside 0-24
%
%   See also: createRecording

if isempty(rec_date) || ~isdatetime(rec_date) || any(isnat(rec_date(:)))
    error('buildRecordingDatetime:NoDate', ...
        'Pick the recording date (there is no behavior session to take it from).');
end

if isempty(rec_hour) || ~isnumeric(rec_hour) || ~isfinite(rec_hour(1)) ...
        || rec_hour(1) < 0 || rec_hour(1) > 24
    error('buildRecordingDatetime:BadHour', ...
        'The recording hour must be between 0 and 24.');
end

rec_dt = dateshift(rec_date(1), 'start', 'day') + hours(rec_hour(1)) + minutes(rec_minutes);
rec_dt = dateshift(rec_dt, 'start', 'second');

recording_datetime = char(rec_dt, 'yyyy-MM-dd HH:mm:ss');
session_date       = char(rec_dt, 'yyyyMMdd_HHmmss');

end
