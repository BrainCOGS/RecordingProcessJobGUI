function jobTableSelected(app, event)
%JOBTABLESELECTED Summary of this function goes here
%   Detailed explanation goes here

app.RerunJobStartButton.Enable = 'off';

if length(unique(event.Indices(:,1))) == 1
    
    app.selectedJobRow = event.Indices(1,1);
    idx_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'job_id'),1);
    
    job_id = app.JobTable.Data{event.Indices(1),idx_job_id_column};
    query.job_id = job_id;
    
    fillJobStatusTable(app, query)
    
    idx_status_job_id = find(ismember(app.COLUMNS_JOB_TABLE,'status_processing_id'),1);
    status_job_id = app.JobTable.Data{event.Indices(1),idx_status_job_id};
    
    if status_job_id <= -1
        app.RerunJobStartButton.Enable = 'on';
    end
    
    this_modality = app.DataTable{app.DataTable.job_id == job_id, 'recording_modality'}{:};
    
    if this_modality == "electrophysiology"
        app.OpenExtGUIButton.Text = 'Open Phy';
    elseif this_modality == "imaging"
        app.OpenExtGUIButton.Text = 'Open Suite2p-GUI';
    end
    
end
