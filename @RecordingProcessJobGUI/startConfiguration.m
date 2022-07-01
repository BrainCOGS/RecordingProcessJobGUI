
function startConfiguration(app, event)

updateBusyLabel(app, 0);
enableSturct.Enable = {'SystemNameDropDown', 'AssociatedBehaviorRigDropDown', 'AssociatedBehaviorRigListBox', ...
    'AddAssociatedRigButton', 'DeleteAssociatedRigButton', 'RecordingModalityDropDown', ...
    'RecordingRootDirectoryEdit', 'ConfigureSystemButton', 'SearchDirectoryButton'};

app.controlEnables(enableSturct);

recording_systems = fetchn(lab.Location & 'system_type="recording"', 'location', 'ORDER BY location');
rigs = fetchn(lab.Location & 'system_type="rig"', 'location', 'ORDER BY location');

modalities = cellstr(app.RecordingModalityTable.recording_modality);

app.SystemNameDropDown.Items = recording_systems;
app.AssociatedBehaviorRigDropDown.Items = rigs;
app.RecordingModalityDropDown.Items = modalities;

% Fill already set variables
if any(matches(recording_systems, app.Configuration.System))
    app.SystemNameDropDown.Value = app.Configuration.System;
end
if ~isempty(app.Configuration.BehaviorRig) && any(matches(rigs, app.Configuration.BehaviorRig{1}))
    app.AssociatedBehaviorRigDropDown.Value = app.Configuration.BehaviorRig{1};
end
if any(matches(modalities, app.Configuration.RecordingModality))
    app.RecordingModalityDropDown.Value = app.Configuration.RecordingModality;
end
if ~isempty(app.Configuration.RecordingRootDirectory)
   app.RecordingRootDirectoryEdit.Value =  app.Configuration.RecordingRootDirectory;
end
updateBusyLabel(app, 1);

end