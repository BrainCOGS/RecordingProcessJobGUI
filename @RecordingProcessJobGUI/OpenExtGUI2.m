
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
%   The script runs through uv (buildUvToolCall / uvToolSpec), which provisions
%   the atlas GUI's python environment on demand, so no hand-built conda env is
%   needed. The command is
%   uv run ... -- python <ibl_atlas_script> -o True -d <data_path>,
%   where -o requests offline mode and -d gives the data directory. A missing uv
%   is reported in an error dialog rather than being interpolated into the
%   command, as is a non-zero exit status from the GUI. MATLAB blocks until the
%   GUI exits, so a uiprogressdlg is shown meanwhile; the command output is
%   echoed to the MATLAB console.
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
%       - buildUvToolCall / uvToolSpec
%       - uv (app.uv_exe), which provisions the environment on demand
%       - ephys_atlas_gui.py (via RecordingProcessJobGUI.ibl_atlas_script)
%
%   See also: OpenExtGUI, buildUvToolCall, uvToolSpec, jobTableSelected, OpenLog

if ~isempty(app.selectedJobRow)
    
    idx_job_id_column = find(ismember(app.COLUMNS_JOB_TABLE,'job_id'),1);
    job_id = app.JobTable.Data{app.selectedJobRow(1),idx_job_id_column};
    
    this_job_path = app.DataTable{app.DataTable.job_id == job_id, 'recording_process_post_path'}{:};
    this_modality = app.DataTable{app.DataTable.job_id == job_id, 'recording_modality'}{:};
    
    if this_modality == "electrophysiology"
        
        data_path = fullfile(app.RootProcessedDirectories.electrophysiology, this_job_path, 'ibl_data');
        
        [system_call, err_msg] = buildUvToolCall(app.uv_exe, 'ibl_atlas', ...
            {RecordingProcessJobGUI.ibl_atlas_script, '-o', 'True', '-d', data_path});
        
        if ~isempty(err_msg)
            uiconfirm(app.UIFigure, ['Cannot open the IBL Atlas GUI. ' err_msg], ...
                '', ...
                'Options',{'OK'}, ...
                'Icon','error');
            return
        end
        
        progressdlg = uiprogressdlg(app.UIFigure, 'Message','Opening IBL Atlas GUI, no progress shown, be patinet');
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
