function match = checkLocaldirSessionMatch(app, local_directory, subject_fullname, session_date)


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
session_date_dt = datetime(session_date, "InputFormat", 'yyyy-MM-dd');
if ~isnat(dir_dt) && dir_dt == session_date_dt
    date_match = true;
end

if date_match && subj_match
    match = true;
end





