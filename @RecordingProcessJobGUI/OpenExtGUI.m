
function OpenExtGUI(app, event)

current_dir = pwd;
success_process = true;
this_err = [];
if ~isempty(app.selectedJobRow)
    
    idx_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'job_id'),1);
    job_id = app.JobTable.Data{app.selectedJobRow(1),idx_job_id_column};
    
    this_job_path = app.DataTable{app.DataTable.job_id == job_id, 'recording_process_post_path'}{:};
    this_modality = app.DataTable{app.DataTable.job_id == job_id, 'recording_modality'}{:};
    
    
    data_path = fullfile(app.RootProcessedDirectories.(this_modality), this_job_path);
    dir_info = dir(data_path);
    dir_info = {dir_info.name};
    
    output_dir_idx = contains(dir_info, '_output');
    output_dir = dir_info(output_dir_idx);
    
    if ~isempty(output_dir)
        output_dir = output_dir{1};
        data_path = fullfile(data_path, output_dir);
        cd(data_path);
        if this_modality == "electrophysiology"
            system_call = [{app.phy_script} {app.py_iblenv_name} {data_path}];
            tool = 'Phy';
        elseif this_modality == "imaging"
            system_call = [{app.suite2p_script} {app.py_iblenv_name}];
            tool = 'suite2p';
        end
        system_call = char(strjoin(string(system_call)));
        progressdlg = uiprogressdlg(app.UIFigure, 'Message',['Opening ', tool ,', no progress shown, be patinet']);
        try
            [out, cmdout] = system(system_call);
            cd(current_dir);
        catch err
            this_err = err;
            success_process = false;
            cd(current_dir);
        end
        if out ~= 0
            success_process = false;
            this_err.message = cmdout;
            cd(current_dir);
        end
        close(progressdlg);
    else
        this_err.message = 'Cannot find sorting directory';
        success_process = false;
    end
    
    if ~success_process
        uiconfirm(app.UIFigure,['Error while opening Phy ' this_err.message], ...
            '', ...
            'Options',{'OK'}, ...
            'Icon','error');
    end
    
    
    
    
end



end
