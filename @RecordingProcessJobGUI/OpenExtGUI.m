
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
%   Both tools are launched by shelling out to uv (app.py_uv), which runs a
%   standalone python launcher declaring its own dependencies inline (PEP 723):
%     - electrophysiology -> app.phy_script (PythonScripts/open_phy.py)
%     - imaging           -> app.suite2p_script (PythonScripts/open_suite2p.py)
%   Both are passed the sorting output directory, and uv resolves each into its
%   own cached environment on first use. This replaces the old .BAT wrappers,
%   which were cmd.exe-only (on macOS zsh rejected them outright) and assumed phy
%   and suite2p lived in a conda env; neither tool needs conda now. If uv could
%   not be found or installed (~app.py_enabled) this reports that instead.
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
%       - open_phy.py / open_suite2p.py (via app.phy_script / app.suite2p_script)
%       - uv (app.py_uv, located by getPythonEnv)
%
%   See also: OpenExtGUI2, jobTableSelected, OpenLog, getPythonEnv

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

    if ~app.py_enabled
        this_err.message = ['uv is not available, so ' char(this_modality) ...
            ' GUIs cannot be launched. Install uv from https://docs.astral.sh/uv/ ' ...
            'and restart the app.'];
        success_process = false;
    elseif ~isempty(output_dir)
        output_dir = output_dir{1};
        data_path = fullfile(data_path, output_dir);
        cd(data_path);
        if this_modality == "electrophysiology"
            launcher = app.phy_script;
            tool = 'Phy';
        elseif this_modality == "imaging"
            launcher = app.suite2p_script;
            tool = 'suite2p';
        end
        % uv run --no-project: the launcher declares its own dependencies inline
        % (PEP 723), so it resolves into its own cached environment rather than
        % the repo's. Paths are quoted to survive spaces.
        system_call = [app.py_uv ' run --no-project "' launcher '" "' data_path '"'];
        progressdlg = uiprogressdlg(app.UIFigure, 'Message',['Opening ', tool ,', no progress shown, be patinet']);
        try
            [out, cmdout] = system(system_call);
            disp(cmdout);
            cd(current_dir);
            if out ~= 0
                success_process = false;
                this_err.message = cmdout;
            end
        catch err
            this_err = err;
            success_process = false;
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
