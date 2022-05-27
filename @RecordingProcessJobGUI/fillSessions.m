
function fillSessions(app, key)

if nargin < 2
    key = [];
end

if isempty(key)
    t = acquisition.SessionStarted();
else
    t = acquisition.SessionStarted & key;
end

%sessions = struct2table(fetch(t.proj('CONCAT(subject_fullname, "         " ,session_date, "         " ,session_number)-> session_name'), ...
%    'session_name', 'ORDER BY session_date desc'));

sessions = fetchDataDJTable(t.proj('CONCAT(subject_fullname, "         " ,session_date, "         " ,session_number)-> session_name'), ...
    [], {'session_name', 'ORDER BY session_date desc'}, "table");

app.BehaviorSessions = sessions;

app.BehaviorSessionDropDown.Items = sessions.session_name;
app.BehaviorSessionDropDown_2.Items = sessions.session_name;

end