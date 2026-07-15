function jobTableSelected(app, event)
%JOBTABLESELECTED Remember the job selected in Tab 4 and show its status history
%
%   CellSelectionCallback for app.JobTable ("Manage Processing Jobs" tab). Acts
%   only when the selection sits inside a single row; a multi-row selection is
%   ignored (and leaves the Rerun button disabled). For a single row it:
%     - stores the row index in app.selectedJobRow, which is what RerunJob,
%       RunJobDiffParams, OpenLog, OpenExtGUI and OpenExtGUI2 later read the
%       job_id from;
%     - fetches that job's status history into app.JobHistoryTable via
%       fillJobStatusTable;
%     - re-enables app.RerunJobStartButton only when the job's
%       status_processing_id is <= -1, i.e. the job errored out and may be reset;
%     - retargets app.OpenExtGUIButton at the right external tool for the job's
%       modality: "Open Phy" for electrophysiology, "Open Suite2p-GUI" for
%       imaging. The button text changes but the callback (OpenExtGUI) does not:
%       OpenExtGUI branches on modality itself.
%
%   Columns are located by name in app.COLUMNS_JOB_TABLE rather than by a fixed
%   index, so the table layout can be reordered without touching this callback.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - CellSelection event; event.Indices(:,1)
%                                      are the selected rows of app.JobTable
%
%   Outputs:
%       None - Sets app.selectedJobRow, fills app.JobHistoryTable, and updates
%              app.RerunJobStartButton.Enable / app.OpenExtGUIButton.Text
%
%   Dependencies:
%       - fillJobStatusTable
%
%   See also: fillJobTable, fillJobStatusTable, RerunJob, OpenExtGUI

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
