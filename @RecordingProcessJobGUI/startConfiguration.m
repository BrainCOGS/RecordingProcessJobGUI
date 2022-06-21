
function startConfiguration(app, event)

updateBusyLabel(app, 0);
enableSturct.Enable = {'SystemNameDropDown', 'AssociatedBehaviorRigDropDown', 'RecordingModalityDropDown', ...
    'RecordingRootDirectoryEdit', 'ConfigureSystemButton', 'SearchDirectoryButton'};

app.controlEnables(enableSturct);

rigs = fetchn(lab.Location, 'location', 'ORDER BY location');
modalities = cellstr(app.RecordingModalityTable.recording_modality);

app.SystemNameDropDown.Items = rigs;
app.AssociatedBehaviorRigDropDown.Items = rigs;
app.RecordingModalityDropDown.Items = modalities;

% Fill already set variables
if any(matches(rigs, app.Configuration.System))
    app.SystemNameDropDown.Value = app.Configuration.System;
end
if any(matches(rigs, app.Configuration.BehaviorRig))
    app.AssociatedBehaviorRigDropDown.Value = app.Configuration.BehaviorRig;
end
if any(matches(modalities, app.Configuration.RecordingModality))
    app.RecordingModalityDropDown.Value = app.Configuration.RecordingModality;
end
if ~isempty(app.Configuration.RecordingRootDirectory)
   app.RecordingRootDirectoryEdit.Value =  app.Configuration.RecordingRootDirectory;
end
updateBusyLabel(app, 1);

end