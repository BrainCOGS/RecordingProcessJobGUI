
function OpenExtGUI2(app, event)

if ~isempty(app.selectedJobRow)
    
    idx_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'job_id'),1);
    job_id = app.JobTable.Data{app.selectedJobRow(1),idx_job_id_column};
    
    this_job_path = app.DataTable{app.DataTable.job_id == job_id, 'recording_process_post_path'}{:};
    this_modality = app.DataTable{app.DataTable.job_id == job_id, 'recording_modality'}{:};
    
    if this_modality == "electrophysiology"
        data_path = fullfile(app.RootProcessedDirectories.electrophysiology, this_job_path, 'ibl_data');
        
        system_call = [{app.py_ibl_env} {RecordingProcessJobGUI.ibl_atlas_script}];
        system_call{end+1} = '-o';
        system_call{end+1} = 'True';
        system_call{end+1} = '-d';
        system_call{end+1} = data_path;
        
        %CellArray to char with spaces
        system_call = char(strjoin(string(system_call)));
        [out, cmdout] = system(system_call);
        
        
    end
    
    
end



end
