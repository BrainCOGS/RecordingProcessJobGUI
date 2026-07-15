function findLikelyBehaviorSessionFromRecDir(app,event)
%FINDLIKELYBEHAVIORSESSIONFROMRECDIR Guess the behavior session that matches a recording dir
%
%   ValueChanged callback for app.RecordingDirectoryDropDown. Convenience only: it
%   pre-selects the most likely entry of app.BehaviorSessionDropDown and colours the
%   dropdown to say how much to trust the guess. The user can always override, and
%   nothing here validates the final choice -- checkLocaldirSessionMatch does that at
%   registration time. restoreColorSessionDropDown clears the colour as soon as the
%   user picks a session by hand.
%
%   Colour code (all constants on the class):
%       app.OKColor (green)      - confident: a unique subject+date+time match
%       app.YellowBColor (yellow)- a subject+date match exists but the times do not
%                                  line up; the first candidate is selected anyway
%       app.ErrorColor (red)     - could not guess; the dropdown is left as-is
%
%   The heuristic, in order:
%     1. Subject. Take the selected row's full_recording_directory from
%        app.RecordingDirectoryTable and walk up to its parent. If that parent
%        contains '_g0' (the SpikeGLX <date>_g0/imec0 layout) walk up once more. The
%        leaf name of that folder, lowercased with separators stripped, is the
%        likely subject name. It must be a substring (case-sensitive `contains`) of
%        exactly ONE unique subject_fullname in app.BehaviorSessions -- zero or
%        several matches means red.
%     2. Date. find_datestr_recording_directory scans the path for the first
%        date-like token; NaT means red. Candidates are then the rows of
%        app.BehaviorSessions for that subject whose session_date equals it.
%     3. No candidate -> red. Exactly one candidate -> select it, green.
%     4. Several candidates -> disambiguate by time. Each candidate's
%        session_start_time ('HH:mm') is compared against the recording directory's
%        modification time (the times_dir column, filled by get_mod_time_directory,
%        also 'HH:mm'). The intent is to take the first behavior session starting at
%        or after the directory time, and to accept it only if it starts within 15
%        minutes; that session is selected green. If no session starts after the
%        directory time, or the gap exceeds 15 minutes, the first candidate row is
%        selected yellow instead.
%   Any error at all is swallowed and turns the dropdown red.
%
%   Note the time comparison only uses the clock time of the two; the date has
%   already been matched in step 2. Despite the inline comment, num_trials is not
%   part of the heuristic.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - DropDown ValueChanged event (unused)
%
%   Outputs:
%       None - Sets app.BehaviorSessionDropDown Value and BackgroundColor
%
%   Dependencies:
%       - find_datestr_recording_directory, get_mod_time_directory (via the
%         times_dir column of app.RecordingDirectoryTable)
%       - app.BehaviorSessions, filled by fillSessions
%
%   See also: restoreColorSessionDropDown, checkLocaldirSessionMatch, fillSessions,
%             postConfigurationActions

%Auto select behavior session from dropdown (if possible)


try
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

grandpa_dir = [fileparts(parent_dir) '\'];
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
        app.BehaviorSessionDropDown.Value = subject_sessions.session_name{1};
        app.BehaviorSessionDropDown.BackgroundColor = app.YellowBColor;
        return
    end

    sel_time = time_diffs(idx_time);

    %If behavior session created 15 min after cannot preselect
    if minutes(sel_time) > 15
        app.BehaviorSessionDropDown.Value = subject_sessions.session_name{1};
        app.BehaviorSessionDropDown.BackgroundColor = app.YellowBColor;
        return;
    end

    subject_sessions = subject_sessions(idx_time,:);
    app.BehaviorSessionDropDown.Value = subject_sessions.session_name{1};
    app.BehaviorSessionDropDown.BackgroundColor = app.OKColor;

end

catch
    app.BehaviorSessionDropDown.BackgroundColor = app.ErrorColor;
end














