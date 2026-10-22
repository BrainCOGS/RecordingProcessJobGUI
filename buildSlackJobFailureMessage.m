function msg = buildSlackJobFailureMessage(action, context, err)
%BUILDSLACKJOBFAILUREMESSAGE Build the Slack text reporting a failed job upload
%
%   Produces
%
%       :rotating_light: RecordingProcessJobGUI: <action> failed
%       • <field>: <value>
%       ...
%       Error: <message>
%
%   Kept free of the DB and the network so it can be tested on its own;
%   notifySlackJobFailure does the sending.
%
%   Inputs:
%       action  (char/string) - What was being done, e.g. 'Job creation'
%       context (struct or [])- Fields listed in order, e.g. system, job_id.
%                               Numbers, logicals, strings and one-element
%                               cells are formatted; empty values read
%                               '(none)', so a job_id of 0 still shows.
%       err     (MException/char/string) - The failure; '' reads '(no message)'
%
%   Outputs:
%       msg (char) - The text, with Slack's control characters (& < >)
%                    escaped so an error or path can't ping or link anything
%
%   See also: notifySlackJobFailure

lines = {sprintf(':rotating_light: RecordingProcessJobGUI: %s failed', ...
    escapeSlack(char(action)))};

if isstruct(context) && isscalar(context)
    fields = fieldnames(context);
    for i = 1:numel(fields)
        lines{end+1} = sprintf('%s %s: %s', char(8226), fields{i}, ...
            escapeSlack(formatValue(context.(fields{i})))); %#ok<AGROW>
    end
end

if isa(err, 'MException')
    err_msg = err.message;
else
    err_msg = char(err);
end
if isempty(strtrim(err_msg))
    err_msg = '(no message)';
end
lines{end+1} = ['Error: ' escapeSlack(err_msg)];

msg = strjoin(lines, newline);

end


function txt = formatValue(value)

if iscell(value) && isscalar(value)
    value = value{1};
end

if isempty(value)
    txt = '(none)';
elseif ischar(value) || isstring(value)
    txt = char(strjoin(string(value), ', '));
elseif islogical(value)
    txt = strjoin(cellstr(string(value)), ', ');
elseif isnumeric(value)
    txt = strjoin(arrayfun(@num2str, value(:)', 'UniformOutput', false), ', ');
else
    txt = ['<' class(value) '>'];
end

end


function txt = escapeSlack(txt)
% & first, so the entities added for < and > are not escaped again.
txt = strrep(txt, '&', '&amp;');
txt = strrep(txt, '<', '&lt;');
txt = strrep(txt, '>', '&gt;');
end
