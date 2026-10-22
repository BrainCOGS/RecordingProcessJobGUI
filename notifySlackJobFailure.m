function sent = notifySlackJobFailure(action, context, err)
%NOTIFYSLACKJOBFAILURE Report a failed job upload to Slack, without ever throwing
%
%   Called from the catch blocks of createRecording, CreateNewJob and RerunJob
%   so a failed upload is seen by the pipeline maintainers, not only by whoever
%   is at the rig. Posts to the 'automation_pipeline_error_notification' webhook
%   in lab.SlackWebhooks, the channel the automatic pipeline already reports its
%   own errors to, so no webhook URL lives in this repo.
%
%   Best effort: the caller is already handling a failure, so anything that
%   goes wrong here (no DB connection, webhook missing, Slack unreachable) is a
%   warning with id notifySlackJobFailure:NotSent, never an error.
%
%   Inputs:
%       action  (char/string) - What failed, e.g. 'Job creation'
%       context (struct or [])- Details to list, e.g. system, job_id
%       err     (MException/char/string) - The failure
%
%   Outputs:
%       sent (logical) - true when Slack accepted the message
%
%   Dependencies:
%       - lab.SlackWebhooks (webhook_name, webhook_url)
%       - buildSlackJobFailureMessage
%
%   See also: buildSlackJobFailureMessage, createRecording, CreateNewJob, RerunJob

WEBHOOK_NAME = 'automation_pipeline_error_notification';
HTTP_TIMEOUT_SECONDS = 10;

sent = false;

try
    if isempty(context)
        context = struct();
    end
    context.machine = getenv('COMPUTERNAME');
    if isempty(context.machine)
        context.machine = getenv('HOSTNAME');
    end

    msg = buildSlackJobFailureMessage(action, context, err);

    webhook = fetch(lab.SlackWebhooks & struct('webhook_name', WEBHOOK_NAME), 'webhook_url');
    if isempty(webhook)
        warning('notifySlackJobFailure:NotSent', ...
            'Slack webhook "%s" not found in lab.SlackWebhooks', WEBHOOK_NAME);
        return
    end

    options = weboptions('MediaType', 'application/json', ...
        'RequestMethod', 'post', 'Timeout', HTTP_TIMEOUT_SECONDS);
    webwrite(webhook(1).webhook_url, struct('text', msg), options);
    sent = true;
catch slack_err
    warning('notifySlackJobFailure:NotSent', ...
        'Could not report the failure to Slack: %s', slack_err.message);
end

end
