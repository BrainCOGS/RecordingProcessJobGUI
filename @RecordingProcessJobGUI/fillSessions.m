
function fillSessions(app, key)

if nargin < 2
    key = [];
end

if isempty(key)
    t = (acquisition.Session * subject.Subject);
else
    t = (acquisition.Session * subject.Subject) & key;
end

%sessions = struct2table(fetch(t.proj('CONCAT(subject_fullname, "         " ,session_date, "         " ,session_number)-> session_name'), ...
%    'session_name', 'ORDER BY session_date desc'));

sessions = fetchDataDJTable(t.proj('CONCAT(subject_fullname, "         " ,session_date, "         " ,session_number)-> session_name', 'user_id'), ...
    [], {'session_name', 'user_id', 'ORDER BY session_date desc'}, "table");

app.BehaviorSessions = sessions;

if ~isempty(sessions)
    app.BehaviorSessionDropDown.Items = sessions.session_name;
end

end