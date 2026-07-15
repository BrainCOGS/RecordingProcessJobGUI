
function configureSystem(app, event)
%CONFIGURESYSTEM Write the System Configuration tab values to disk and bring the GUI up
%
%   ButtonPushed callback for app.ConfigureSystemButton, and the commit half of the
%   configuration flow that startConfiguration opens. Harvests the four fields from
%   the tab controls into app.Configuration, saves them to app.ConfFileFullName
%   (system_conf_job_gui.json), re-locks the tab controls, and then re-reads the file
%   through checkConfiguration so that what the GUI runs on is exactly what was
%   persisted - not the in-memory values.
%
%   Field sources:
%       System                 <- app.SystemNameDropDown.Value
%       BehaviorRig            <- app.AssociatedBehaviorRigListBox.Items (the whole
%                                 list, as a string array, so several behavior rigs
%                                 can be paired with one recording system)
%       RecordingModality      <- app.RecordingModalityDropDown.Value
%       RecordingRootDirectory <- app.RecordingRootDirectoryEdit.Value
%
%   Backslashes in RecordingRootDirectory are doubled before saving because
%   saveJSONfile writes the string verbatim and does not escape it: a Windows path
%   must reach the file as "D:\\NPX_DATA" so that jsondecode gives back D:\NPX_DATA.
%
%   If checkConfiguration accepts the result, postConfigurationActions sets the app
%   up for this configuration, a success dialog is shown and FillEverything refreshes
%   every tab. If it does not (some field is still empty), a warning dialog is shown
%   and app.ConfigurationNeededLabel goes back to the red "Configuration needed"
%   state.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - Button ButtonPushed event (unused)
%
%   Outputs:
%       None - Writes system_conf_job_gui.json, updates app.Configuration, disables
%              the System Configuration tab controls, and either configures and
%              refreshes the whole GUI or flags configuration as still needed
%
%   Dependencies:
%       - saveJSONfile
%       - checkConfiguration, postConfigurationActions, FillEverything,
%         controlEnables, updateBusyLabel
%
%   See also: startConfiguration, checkConfiguration, postConfigurationActions,
%             selectRecordingRootDirectory

updateBusyLabel(app, 0);

app.Configuration.System =  app.SystemNameDropDown.Value;
app.Configuration.BehaviorRig = string(app.AssociatedBehaviorRigListBox.Items);
app.Configuration.RecordingModality = app.RecordingModalityDropDown.Value;
app.Configuration.RecordingRootDirectory = app.RecordingRootDirectoryEdit.Value;

app.Configuration.RecordingRootDirectory = strrep(app.Configuration.RecordingRootDirectory ,'\','\\');

saveJSONfile(app.Configuration, app.ConfFileFullName);

enableSturct.Disable = {'SystemNameDropDown', 'AssociatedBehaviorRigDropDown', 'AssociatedBehaviorRigListBox'...
    'AddAssociatedRigButton', 'DeleteAssociatedRigButton', 'RecordingModalityDropDown', ...
    'RecordingRootDirectoryEdit', 'ConfigureSystemButton', 'SearchDirectoryButton'};

app.controlEnables(enableSturct);

conf_done = checkConfiguration(app);

if conf_done
    postConfigurationActions(app);
    
    uiconfirm(app.UIFigure,'System was configured correctly !', ...
          'Configuration Success', ...
          'Options',{'OK'}, ...
          'Icon','success');
    FillEverything(app);
else
     uiconfirm(app.UIFigure,'System was not configured correctly !', ...
         'Configuration failed', ...
         'Options',{'OK'}, ...
         'Icon','warning');
     app.ConfigurationNeededLabel.BackgroundColor = app.ErrorColor;
     app.ConfigurationNeededLabel.Text = {'Configuration'; 'needed'};
end

updateBusyLabel(app, 1);

end