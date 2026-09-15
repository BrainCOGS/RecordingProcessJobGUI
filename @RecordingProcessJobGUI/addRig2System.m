
function addRig2System(app, event)
%ADDRIG2SYSTEM Add the selected behavior rig to this system's associated rig list
%
%   ButtonPushed callback for app.AddAssociatedRigButton on the System Configuration
%   tab. One recording system can serve several behavior rigs, so BehaviorRig is a
%   list rather than a single name: this appends the rig currently chosen in
%   app.AssociatedBehaviorRigDropDown (a lab.Location with system_type="rig") to
%   app.AssociatedBehaviorRigListBox.
%
%   Duplicates are ignored - a rig already in the list box is not added again.
%
%   This only edits the list box. The list is not persisted until configureSystem
%   reads AssociatedBehaviorRigListBox.Items into app.Configuration.BehaviorRig and
%   writes system_conf_job_gui.json.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - Button ButtonPushed event (unused)
%
%   Outputs:
%       None - Appends to app.AssociatedBehaviorRigListBox.Items
%
%   See also: dropRig2System, configureSystem, startConfiguration, checkConfiguration

new_item = app.AssociatedBehaviorRigDropDown.Value;

if (sum(ismember(app.AssociatedBehaviorRigListBox.Items, new_item)) == 0)
    app.AssociatedBehaviorRigListBox.Items = [app.AssociatedBehaviorRigListBox.Items new_item];
end

end