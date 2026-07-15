
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
%   The script is run directly through the iblenv python interpreter
%   (app.py_ibl_env, located by getPythonEnv) rather than through a .BAT wrapper:
%   the command is
%   <py_ibl_env> RecordingProcessJobGUI.ibl_atlas_script -o True -d <data_path>,
%   where -o requests offline mode and -d gives the data directory. MATLAB blocks
%   until the GUI exits, so a uiprogressdlg is shown meanwhile; the command output
%   is echoed to the MATLAB console.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ButtonPushed event (unused)
%
%   Outputs:
%       None - Launches the IBL ephys atlas GUI on the job's ibl_data directory
%
%   Dependencies:
%       - ephys_atlas_gui.py (via RecordingProcessJobGUI.ibl_atlas_script)
%       - iblenv conda environment (app.py_ibl_env)
%
%   See also: OpenExtGUI, jobTableSelected, OpenLog, getPythonEnv

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
        progressdlg = uiprogressdlg(app.UIFigure, 'Message','Opening IBL Atlas GUI, no progress shown, be patinet');
        [out, cmdout] = system(system_call);
        disp(cmdout);
        close(progressdlg);
        
        
    end
    
    
end



end
