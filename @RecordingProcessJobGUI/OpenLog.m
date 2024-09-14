
function OpenLog(app, event)

if event.Source == app.OpenOutLogButton
    path = app.OutputLogsPath;
else
    path = app.ErrorLogsPath;
end

if ~isempty(app.selectedJobRow)
    
    idx_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'job_id'),1);
    job_id = app.JobTable.Data{app.selectedJobRow(1),idx_job_id_column};
    
    fullpath = fullfile(path, ['job_id_' num2str(job_id) '.log']);
    
    if ispc
        system(['notepad ' fullpath]);
    elseif ismac
        system(['open ' fullpath]);
    end
    
end

end