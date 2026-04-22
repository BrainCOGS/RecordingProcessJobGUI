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
expressions = {'\d{8}', '\d{4}-\d{2}-\d{2}', '\d{4}-\d{2}-\d{4}'}; 
all_numdate_matches = {};
for i =1:length(dir_pieces)

    for j=1:length(expressions)

        matches = regexp(dir_pieces{i}, expressions{j}, 'match');
        all_numdate_matches = [all_numdate_matches matches];
    end
end


%% Extract date from numeric expressions in dir
date_formats = {'yyyyMMdd','MMddyyyy','MMddyy','dd-MM-yyyy','yyyy-MM-dd','MM-dd-yyyy'};
dir_dt = NaT;
date_match = false;
for i =1:length(all_numdate_matches)

    for j=1:length(date_formats)

        try
            dir_dt = datetime(all_numdate_matches{i}, "InputFormat", date_formats{j});
            break;
        catch
        end
    end

end

%% Compare dates
session_date_dt = datetime(session_date, "InputFormat", 'yyyy-MM-dd');
if ~isnat(dir_dt) && dir_dt == session_date_dt
    date_match = true;
end

if date_match && subj_match
    match = true;
end





