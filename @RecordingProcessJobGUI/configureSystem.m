
function configureSystem(app, event)

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