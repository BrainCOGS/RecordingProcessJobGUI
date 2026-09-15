
function startConfiguration(app, event)
%STARTCONFIGURATION Unlock the System Configuration tab and populate its choices
%
%   ButtonPushed callback for app.StartConfigurationButton. The System Configuration
%   tab starts read-only so a working rig cannot be reconfigured by a stray click;
%   this is the deliberate "I want to edit the setup" step that enables the controls.
%
%   Enables every editable control on the tab (SystemNameDropDown,
%   AssociatedBehaviorRigDropDown / ListBox, Add/DeleteAssociatedRigButton,
%   RecordingModalityDropDown, RecordingRootDirectoryEdit, SearchDirectoryButton,
%   ConfigureSystemButton) via app.controlEnables, then fills the dropdowns from the
%   database rather than from a hard-coded list: recording systems are lab.Location
%   with system_type="recording", behavior rigs are lab.Location with
%   system_type="rig" (both ORDER BY location), and modalities come from
%   app.RecordingModalityTable.recording_modality (recording.Modality, fetched in
%   startupFcn).
%
%   Any value already present in app.Configuration is pre-selected, but only if it
%   still exists in the corresponding dropdown - a rig or system that was renamed or
%   removed from lab.Location is silently left unselected instead of erroring. Only
%   the first behavior rig (BehaviorRig{1}) seeds the dropdown; the full list is
%   shown in AssociatedBehaviorRigListBox, which checkConfiguration already filled.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - Button ButtonPushed event (unused)
%
%   Outputs:
%       None - Enables the System Configuration tab controls and populates
%              app.SystemNameDropDown, app.AssociatedBehaviorRigDropDown,
%              app.RecordingModalityDropDown and app.RecordingRootDirectoryEdit
%
%   Dependencies:
%       - DataJoint tables: lab.Location, recording.Modality (via
%         app.RecordingModalityTable)
%       - controlEnables, updateBusyLabel
%
%   See also: configureSystem, checkConfiguration, addRig2System, dropRig2System

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