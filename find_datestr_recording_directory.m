function dir_dt = find_datestr_recording_directory(directory)
%FIND_DATESTR_RECORDING_DIRECTORY Guess the recording date from a directory path
%
%   Recording directories are named by the rig with the acquisition date
%   somewhere in the path, but the convention differs between rigs. This
%   recovers that date so Tab 1 can guess which behavior session a recording
%   belongs to: findLikelyBehaviorSessionFromRecDir uses it to preselect the
%   Behavior Session dropdown, and checkLocaldirSessionMatch uses it to check a
%   directory against a session the user already chose.
%
%   The path is split on "/" and every piece is scanned with these patterns,
%   in this order, collecting all matches:
%       \d{8}             - eight consecutive digits, e.g. 20250714
%       \d{4}-\d{2}-\d{2} - e.g. 2025-07-14
%       \d{4}-\d{2}-\d{4} - collected but no format below can parse it
%
%   Each match is then handed to datetime() against these InputFormats, in
%   order, and the first that parses wins:
%       yyyyMMdd, MMddyyyy, MMddyy, dd-MM-yyyy, yyyy-MM-dd, MM-dd-yyyy
%
%   Order matters and resolves ambiguity: an eight-digit match is read as
%   yyyyMMdd before MMddyyyy is tried, and a hyphenated 4-2-2 match is offered
%   to dd-MM-yyyy first (which fails on a four-digit day) and so lands on
%   yyyy-MM-dd. The search stops at the first match that parses, so the
%   left-most date-like piece of the path wins.
%
%   Inputs:
%       directory (char/string) - Recording directory path to scan. Callers
%                                 pass the full local path from
%                                 app.RecordingDirectoryTable.full_recording_directory
%
%   Outputs:
%       dir_dt (datetime) - The parsed date, with whatever Format datetime
%                           defaults to (callers set dir_dt.Format themselves
%                           before comparing). NaT when nothing date-like is
%                           found or nothing parses - callers test isnat(dir_dt)
%                           and give up on preselecting
%
%   See also: findLikelyBehaviorSessionFromRecDir, checkLocaldirSessionMatch,
%   get_mod_time_directory, postConfigurationActions

dir_dt = NaT;

dir_pieces = split(directory, "/");

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
for i =1:length(all_numdate_matches)

    for j=1:length(date_formats)

        try
            dir_dt = datetime(all_numdate_matches{i}, "InputFormat", date_formats{j});
            break;
        catch
        end
    end
    if ~isnat(dir_dt)
        break;
    end

end


end

