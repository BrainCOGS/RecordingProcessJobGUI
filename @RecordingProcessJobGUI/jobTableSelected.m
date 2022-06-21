function jobTableSelected(app, event)
%JOBTABLESELECTED Summary of this function goes here
%   Detailed explanation goes here

job_id = app.UITable.Data{event.Indices(1),1};
query.job_id = job_id;

columns = [app.COLUMNS_JOB_STATUS_TABLE, {'ORDER BY status_timestamp desc'}];

job_status_history = fetch(app.job_id_history_table_class() & query,columns{:});

if ~isempty(job_status_history)
    data = struct2cell(job_status_history);
    app.JobHistoryTable.Data = data';
end

end

