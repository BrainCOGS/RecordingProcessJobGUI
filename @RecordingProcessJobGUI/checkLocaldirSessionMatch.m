function match = checkLocaldirSessionMatch(app, local_directory, subject_fullname, session_date)
%CHECKLOCALDIRSESSIONMATCH Test whether a local recording dir plausibly matches a session
%
%   Sanity check used by createRecordingButton before anything is written: it is
%   easy to pick the wrong behavior session in the dropdown, so this confirms the
%   directory on disk actually looks like it belongs to that subject on that day.
%   A false result does not block registration -- createRecordingButton only raises
%   a warning dialog the user can accept.
%
%   Two independent tests, both of which must pass:
%     - Subject: the nickname (the part of subject_fullname after the first '_') is
%       searched for as a substring in any '/'-separated piece of local_directory.
%       Case sensitive.
%     - Date: find_datestr_recording_directory scans the path for the first thing
%       that parses as a date (\d{8} or \d{4}-\d{2}-\d{2} style, tried against
%       several formats) and it must equal session_date exactly.
%   local_directory is expected to already use forward slashes.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object (unused)
%       local_directory              - Full local path of the recording directory,
%                                      forward-slash separated
%       subject_fullname             - '<user_id>_<nickname>' of the session
%       session_date                 - Session date as 'yyyy-MM-dd'
%
%   Outputs:
%       match (logical) - true only if both the subject nickname and a date
%                         matching session_date were found in the path
%
%   Dependencies:
%       - find_datestr_recording_directory
%
%   See also: createRecordingButton, findLikelyBehaviorSessionFromRecDir

match = false;


dir_pieces = split(local_directory, "/");


%% Find subject nickname in dir
subject_nickname = split(subject_fullname, "_");
subj_match = false;
for i =1:length(dir_pieces)

    idx = strfind(dir_pieces{i},subject_nickname{2});
    if ~isempty(idx)
        subj_match = true;
        break;
    end
end

%% Find all expressions that looks like date in dir
dir_dt = find_datestr_recording_directory(local_directory);

%% Compare dates
date_match = false;
session_date_dt = datetime(session_date, "InputFormat", 'yyyy-MM-dd');
if ~isnat(dir_dt) && dir_dt == session_date_dt
    date_match = true;
end

if date_match && subj_match
    match = true;
end





