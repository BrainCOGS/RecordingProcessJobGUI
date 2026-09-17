
function OpenExtGUI(app, event)
%OPENEXTGUI Open Phy (ephys) or the suite2p GUI (imaging) on the selected job's results
%
%   ButtonPushed callback for app.OpenExtGUIButton on the "Manage Processing Jobs"
%   tab. This is the modality-dependent one of the two external-GUI buttons:
%   jobTableSelected relabels the button 'Open Phy' or 'Open Suite2p-GUI' to match
%   the selected job, and this function branches on the same modality to choose
%   the tool. Its sibling OpenExtGUI2 handles the ephys-only IBL atlas GUI.
%
%   The job_id comes from the row cached in app.selectedJobRow (column located by
%   name in app.COLUMNS_JOB_TABLE); recording_process_post_path and
%   recording_modality are then read out of the cached app.DataTable rather than
%   re-queried. The results live under
%   app.RootProcessedDirectories.<modality>/<post_path>, and inside it this looks
%   for the sorting output subdirectory, matched as a name containing both 'kil'
%   (kilosort) and '_output'. If no such directory exists the function reports
%   'Cannot find sorting directory' and gives up.
%
%   Both tools are launched through uv (buildUvToolCall / uvToolSpec), which
%   provisions each tool's python environment on demand:
%     - electrophysiology -> phy template-gui params.py
%     - imaging           -> suite2p
%   Both rely on the cd into the sorting output directory that this function
%   performs first, since that is where phy reads params.py from. They previously
%   went through open_phy.BAT / open_suite2p.BAT, conda-activate wrappers that
%   only ran on Windows and depended on hand-built conda envs.
%
%   MATLAB blocks until the external GUI exits; a uiprogressdlg is shown meanwhile
%   because neither tool reports progress back. The working directory is restored
%   to where it started before returning.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ButtonPushed event (unused)
%
%   Outputs:
%       None - Launches Phy or the suite2p GUI on the job's sorting output, or
%              shows an error dialog
%
%   Dependencies:
%       - buildUvToolCall / uvToolSpec
%       - uv (app.uv_exe), which provisions the environments on demand
%
%   See also: OpenExtGUI2, buildUvToolCall, uvToolSpec, jobTableSelected, OpenLog

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

    output_dir_idx =  contains(dir_info, 'kil') & contains(dir_info, '_output');
    output_dir = dir_info(output_dir_idx);

    if ~isempty(output_dir)
        output_dir = output_dir{1};
        data_path = fullfile(data_path, output_dir);
        cd(data_path);
        if this_modality == "electrophysiology"
            % phy reads the sorting output from the working directory, which
            % was set to data_path above; params.py is the file the sorter
            % writes there (the old .BAT asked for a win_params.py that this
            % pipeline never produces).
            tool_name = 'phy';
            tool_args = {'template-gui', 'params.py'};
            tool = 'Phy';
        elseif this_modality == "imaging"
            tool_name = 'suite2p';
            tool_args = {};
            tool = 'suite2p';
        end

        [system_call, err_msg] = buildUvToolCall(app.uv_exe, tool_name, tool_args);
        if ~isempty(err_msg)
            uiconfirm(app.UIFigure, ['Cannot open ' tool '. ' err_msg], ...
                '', ...
                'Options',{'OK'}, ...
                'Icon','error');
            cd(current_dir);
            return
        end

        progressdlg = uiprogressdlg(app.UIFigure, 'Message',['Opening ', tool ,', no progress shown, be patinet']);
        try
            [out, cmdout] = system(system_call);
            disp(cmdout);
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
