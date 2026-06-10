
function fillSessions(app, key)


date_key = ['session_date > "' char(datetime('today', 'Format', 'yyyy-MM-dd') - days(180)) '"'];

if nargin < 2
    key = [];
end

if isempty(key)
    t = (acquisition.Session * subject.Subject) & date_key;
else
    t = (acquisition.Session * subject.Subject) & key & date_key;
end



sessions  = struct2table(fetch(t,'user_id', 'session_start_time', 'num_trials','session_performance', 'ORDER BY session_date desc, session_number desc'),...
    'AsArray', true);

space_cell = repmat({'           '},height(sessions),1);


sessions.session_start_time = cellfun(@(x) x(12:16),sessions.session_start_time,'UniformOutput',false);

sessions.session_number_char = num2str(sessions.session_number);
sessions.num_trials_char = strcat(repmat({'n_tr='},height(sessions),1),num2str(sessions.num_trials));
sessions.session_performance_char = strcat(repmat({'perf='},height(sessions),1),num2str(sessions.session_performance,'%.0f'));

sessions.session_name = strcat(sessions.subject_fullname,space_cell, ...
    sessions.session_date,space_cell, ...
    sessions.session_number_char, space_cell, ...
    sessions.session_start_time, space_cell, ...
    sessions.num_trials_char, space_cell, ...
    sessions.session_performance_char);

%sessions = struct2table(fetch(t.proj('CONCAT(subject_fullname, "         " ,session_date, "         " ,session_number)-> session_name'), ...
%    'session_name', 'ORDER BY session_date desc'));

%sessions = fetchDataDJTable(t.proj('CONCAT(subject_fullname, "         " ,session_date, "         " ,session_number)-> session_name', 'user_id'), ...
%    [], {'session_name', 'user_id', 'ORDER BY session_date desc'}, "table");

app.BehaviorSessions = sessions;

if ~isempty(sessions)
    app.BehaviorSessionDropDown.Items = sessions.session_name;
end

end