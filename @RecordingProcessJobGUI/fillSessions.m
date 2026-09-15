
function fillSessions(app, key)
%FILLSESSIONS Fill the behavior session dropdown for the rigs this GUI serves
%
%   Populates app.BehaviorSessionDropDown (Add Recording tab, GridLayout2) with the
%   behavior sessions a finished recording can be linked to, and caches the backing table
%   in app.BehaviorSessions so later steps (session selection, recording insert) can
%   recover the real primary key from the displayed string.
%
%   Queries acquisition.Session * subject.Subject restricted by key AND a hardcoded
%   180-day window (session_date > today - 180 days), ordered by session_date then
%   session_number, both descending, so the newest session is first. Each row is
%   rendered into a human-readable session_name column by concatenating, separated by
%   11-space gutters:
%       subject_fullname | session_date | session_number | HH:MM | n_tr=<num_trials> |
%       perf=<session_performance rounded to integer>
%   The HH:MM field is characters 12:16 of session_start_time. The fetched columns kept
%   in app.BehaviorSessions are the primary key (subject_fullname, session_date,
%   session_number) plus user_id, session_start_time, num_trials, session_performance
%   and the derived *_char / session_name columns.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The main application object
%       key (struct | char | [])     - Optional DataJoint restriction on
%                                      acquisition.Session * subject.Subject. startupFcn
%                                      and postConfigurationActions call it with
%                                      cell2struct(app.Configuration.BehaviorRig',
%                                      'session_location'), i.e. a struct array with one
%                                      session_location field per configured behavior
%                                      rig, which ORs the rigs together. Defaults to []
%                                      (every rig, still within the 180-day window).
%
%   Outputs:
%       None - Sets app.BehaviorSessions (table) and app.BehaviorSessionDropDown.Items
%
%   Dependencies:
%       - DataJoint: acquisition.Session, subject.Subject
%
%   See also: fillSubjects, postConfigurationActions, startupFcn, checkBoxSessionRecording


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