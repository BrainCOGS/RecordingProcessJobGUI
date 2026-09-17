
function OpenExtGUI2(app, event)
%OPENEXTGUI2 Open the IBL ephys atlas GUI on the selected job's aligned data
%
%   ButtonPushed callback for app.OpenExtGUIButton2 ('Open IBL-Atlas') on the
%   "Manage Processing Jobs" tab. Unlike its sibling OpenExtGUI, which switches
%   between Phy and suite2p, this button serves one tool only: the IBL
%   electrophysiology atlas GUI, used to align probe tracks to the Allen atlas. It
%   is therefore electrophysiology-only, and silently does nothing when the
%   selected job is an imaging job (the button stays enabled either way).
%
%   The job_id comes from the row cached in app.selectedJobRow (column located by
%   name in app.COLUMNS_JOB_TABLE); recording_process_post_path and
%   recording_modality are read out of the cached app.DataTable rather than
%   re-queried. The GUI is pointed at the ibl_data subdirectory of the job's
%   results, i.e.
%   app.RootProcessedDirectories.electrophysiology/<post_path>/ibl_data, which is
%   where the pipeline writes the data converted to IBL (ONE) format.
%
%   The GUI is launched through uv (app.py_uv), which runs a standalone launcher
%   declaring its dependencies inline (PEP 723):
%
%       "<uv>" run --no-project "<app.ibl_atlas_script>" -o True -d <data_path>
%
%   where -o requests offline mode and -d gives the data directory. The launcher
%   (PythonScripts/open_ibl_atlas.py) installs iblapps straight from upstream, so
%   no hand-built iblenv conda env is needed and the in-tree copy of iblapps is
%   gone. When uv could not be found or installed (~app.py_enabled) that is
%   reported instead of launching nothing. A non-zero exit status is reported
%   too, rather than discarded. MATLAB blocks until the GUI exits, so a
%   uiprogressdlg is shown meanwhile; the command output is echoed to the console.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ButtonPushed event (unused)
%
%   Outputs:
%       None - Launches the IBL ephys atlas GUI on the job's ibl_data directory,
%              or shows an error dialog
%
%   Dependencies:
%       - open_ibl_atlas.py (via RecordingProcessJobGUI.ibl_atlas_script)
%       - uv (app.py_uv, located by getPythonEnv)
%       - buildUvScriptCall
%
%   See also: OpenExtGUI, jobTableSelected, OpenLog, getPythonEnv

if ~isempty(app.selectedJobRow)
    
    idx_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'job_id'),1);
    job_id = app.JobTable.Data{app.selectedJobRow(1),idx_job_id_column};
    
    this_job_path = app.DataTable{app.DataTable.job_id == job_id, 'recording_process_post_path'}{:};
    this_modality = app.DataTable{app.DataTable.job_id == job_id, 'recording_modality'}{:};
    
    if this_modality == "electrophysiology"
        
        data_path = fullfile(app.RootProcessedDirectories.electrophysiology, this_job_path, 'ibl_data');
        
        if ~app.py_enabled
            % uv provisions the atlas environment, so without it there is
            % nothing to launch. Previously an empty interpreter was
            % interpolated into the command, which made string() fail with
            % "Conversion from cell failed" instead of saying what was wrong.
            uiconfirm(app.UIFigure, ...
                ['uv is not installed, so the IBL Atlas GUI cannot be ' ...
                 'launched. Install it from https://docs.astral.sh/uv/ ' ...
                 'and restart the app.'], ...
                '', ...
                'Options',{'OK'}, ...
                'Icon','error');
            return
        end
        
        [system_call, err_msg] = buildUvScriptCall(app.py_uv, ...
            RecordingProcessJobGUI.ibl_atlas_script, {'-o','True','-d',data_path});
        if ~isempty(err_msg)
            uiconfirm(app.UIFigure, ['Cannot open the IBL Atlas GUI. ' err_msg], ...
                '', 'Options',{'OK'}, 'Icon','error');
            return
        end
        
        progressdlg = uiprogressdlg(app.UIFigure, 'Message','Opening IBL Atlas GUI, no progress shown, be patinet');
        % onCleanup so the dialog closes even when system() throws; it used to
        % leak and leave the app with a modal progress bar over it.
        cleanup_dlg = onCleanup(@() close(progressdlg));
        [out, cmdout] = system(system_call);
        disp(cmdout);
        clear cleanup_dlg
        
        if out ~= 0
            uiconfirm(app.UIFigure, ['Error while opening the IBL Atlas GUI: ' cmdout], ...
                '', ...
                'Options',{'OK'}, ...
                'Icon','error');
        end
        
        
    end
    
    
end



end
