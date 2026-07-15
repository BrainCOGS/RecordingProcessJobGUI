function folder_time = get_mod_time_directory(folder)
%GET_MOD_TIME_DIRECTORY Get a directory's modification time as an HH:mm string
%
%   Returns the time of day a recording directory was last modified, used as a
%   proxy for when the recording was acquired. postConfigurationActions calls
%   it for every discovered recording directory to build
%   app.RecordingDirectoryTable.times_dir, which is both shown in the Recording
%   Directory dropdown and used by findLikelyBehaviorSessionFromRecDir to pick
%   the behavior session that started closest after the recording.
%
%   Implemented by listing the directory and reading the date of its first
%   entry, which is the '.' entry standing for the directory itself. That date
%   is the char string dir() produces, 'dd-mmm-yyyy HH:MM:SS', from which
%   characters 13:17 are sliced out - the HH:mm field. Only the time of day is
%   returned; the date is discarded (find_datestr_recording_directory supplies
%   the date instead).
%
%   Inputs:
%       folder (char) - Path to the directory to stat
%
%   Outputs:
%       folder_time (char) - Modification time of day as 'HH:mm', e.g. '14:32'.
%                            Callers parse it with
%                            datetime(..., 'InputFormat', 'HH:mm')
%
%   See also: find_datestr_recording_directory, postConfigurationActions,
%   findLikelyBehaviorSessionFromRecDir


info = dir(folder);

folder_datetime = info(1).date;

folder_time = folder_datetime(13:17);

end




