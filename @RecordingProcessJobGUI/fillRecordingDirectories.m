function fillRecordingDirectories(app, event)
%FILLRECORDINGDIRECTORIES Scan the recording root directory and fill the Recording Directory dropdown
%
%   Called from postConfigurationActions once the configuration is valid, and as
%   the ButtonPushed callback of app.RefreshRecordingDirectoriesButton on the Add
%   Recording tab, so recordings copied in while the GUI is open can be picked
%   without re-running Configure.
%
%   find_recording_directories walks app.Configuration.RecordingRootDirectory for
%   folders directly holding files that match app.FileExtensions, keeping only
%   the top folder when hits are nested (ephys probe subfolders, imaging
%   pipeline subfolders).
%
%   Builds app.RecordingDirectoryTable with columns full_recording_directory,
%   times_dir (last-modified time from get_mod_time_directory), recording_dir
%   (path relative to the root) and rec_dir_dropdown (relative path + time, what
%   the user picks from). With no hits the dropdown reads 'No recordings found'
%   and app.CreateProcessingJobButton is disabled. The previously selected
%   directory stays selected if it is still there.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - Button ButtonPushed event (optional). When
%                                      given (the Refresh button), the busy label
%                                      is shown during the walk; configureSystem
%                                      manages it itself otherwise
%
%   Outputs:
%       None - Sets app.RecordingDirectoryTable, app.RecordingDirectoryDropDown
%              and app.CreateProcessingJobButton.Enable
%
%   See also: find_recording_directories, postConfigurationActions,
%   get_mod_time_directory, findLikelyBehaviorSessionFromRecDir

from_button = nargin > 1;
if from_button
    updateBusyLabel(app, 0);
end

previous_value = app.RecordingDirectoryDropDown.Value;

root_dir = char(app.Configuration.RecordingRootDirectory);
rec_dirs = find_recording_directories(root_dir, app.FileExtensions);

if ~isempty(rec_dirs)

    app.RecordingDirectoryTable = cell2table(rec_dirs,'VariableNames',{'full_recording_directory'});
    app.RecordingDirectoryTable.times_dir = cellfun(@get_mod_time_directory, rec_dirs,'UniformOutput',0);
    app.RecordingDirectoryTable.recording_dir =  strrep(rec_dirs, root_dir, '');

    space_cell = repmat({'           '},height(app.RecordingDirectoryTable),1);

    app.RecordingDirectoryTable.rec_dir_dropdown = strcat(app.RecordingDirectoryTable.recording_dir,space_cell, ...
        app.RecordingDirectoryTable.times_dir);

    app.RecordingDirectoryDropDown.Items = app.RecordingDirectoryTable.rec_dir_dropdown;
    if any(strcmp(app.RecordingDirectoryDropDown.Items, previous_value))
        app.RecordingDirectoryDropDown.Value = previous_value;
    end
    app.CreateProcessingJobButton.Enable = 'on';
else
    app.RecordingDirectoryDropDown.Items = {'No recordings found'};
    app.CreateProcessingJobButton.Enable = 'off';
end

if from_button
    updateBusyLabel(app, 1);
end

end
