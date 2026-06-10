function findLikelyBehaviorSessionFromRecDir(app,event)

%Auto select behavior session from dropdown (if possible)

%Get recording directory info
idx_recdir_table = find(ismember(app.RecordingDirectoryTable.rec_dir_dropdown, app.RecordingDirectoryDropDown.Value),1,'first');

local_directory = app.RecordingDirectoryTable{idx_recdir_table,'full_recording_directory'};
local_directory = local_directory{:};

%find likely subject name (parent from final directory)
parent_dir = fileparts(local_directory);

%If rec directory is in form _g0/imec0
if contains(parent_dir,'_g0')
    parent_dir = fileparts(parent_dir);
end

grandpa_dir = fileparts(parent_dir);
likely_subject_name = strrep(parent_dir,grandpa_dir,'');
likely_subject_name = lower(strrep(likely_subject_name,'\',''));

%Find subject in all subject names from behavior sessions
all_subjects = unique(app.BehaviorSessions.subject_fullname);
idx_subject = contains(all_subjects, likely_subject_name); 

%If there is no match (or more than one could not preselect behavior session)
if sum(idx_subject) ~= 1
    app.BehaviorSessionDropDown.BackgroundColor = app.ErrorColor;
    return 
end
idx_subject = find(idx_subject,1,'first');
this_subject = all_subjects{idx_subject};


%% Find all expressions that looks like date in dir
dir_dt = find_datestr_recording_directory(local_directory);

%If we cannot find datelike thing in recording directory cannot preselect
%behavior session
if isnat(dir_dt)
    app.BehaviorSessionDropDown.BackgroundColor = app.ErrorColor;
    return
end

% Filter possible sessions based on date and subject
dir_dt.Format = 'yyyy-MM-dd';
formatted_date = char(dir_dt);
subject_sessions = app.BehaviorSessions(ismember(app.BehaviorSessions.subject_fullname,this_subject) & ...
    ismember(app.BehaviorSessions.session_date,formatted_date),:);

%If no session find for subject & date cannot preselect
if height(subject_sessions) == 0
    app.BehaviorSessionDropDown.BackgroundColor = app.ErrorColor;
    return;
%If there is only one possible session, select that one
elseif height(subject_sessions) == 1
    app.BehaviorSessionDropDown.Value = subject_sessions.session_name{1};
    app.BehaviorSessionDropDown.BackgroundColor = app.OKColor;
%If more than one possibility, check time and num_trials
else

    %Find closest session time to recording directory time
    all_times_sessions = cellfun(@(x)  datetime(x, 'InputFormat', 'HH:mm'),...
        subject_sessions.session_start_time);

    rec_dir_time = app.RecordingDirectoryTable{idx_recdir_table,'times_dir'};
    rec_dir_time = rec_dir_time{1};
    rec_dir_time = datetime(rec_dir_time, 'InputFormat', 'HH:mm');

    %Find first behavior session after recording directory creation
    time_diffs = all_times_sessions - rec_dir_time;
    idx_time = find(time_diffs>=0,1,'first');

    %If no session after, cannot preselect
    if isempty(idx_time)
        app.BehaviorSessionDropDown.BackgroundColor = app.ErrorColor;
        return
    end

    sel_time = time_diffs(idx_time);

    %If behavior session created 15 min after cannot preselect
    if minutes(sel_time) > 15
        app.BehaviorSessionDropDown.BackgroundColor = app.ErrorColor;
        return;
    end

    subject_sessions = subject_sessions(idx_time,:);
    app.BehaviorSessionDropDown.Value = subject_sessions.session_name{1};
    app.BehaviorSessionDropDown.BackgroundColor = app.OKColor;

end














