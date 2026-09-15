
function dropRig2System(app, event)
%DROPRIG2SYSTEM Remove the selected behavior rig(s) from this system's rig list
%
%   ButtonPushed callback for app.DeleteAssociatedRigButton on the System
%   Configuration tab, and the counterpart to addRig2System. Removes whatever is
%   currently selected in app.AssociatedBehaviorRigListBox from that list box's
%   Items; with nothing selected it does nothing.
%
%   Removal is by value, not by index: the selected value is matched against Items
%   with ismember, so a multi-selection is handled in one pass.
%
%   This only edits the list box. The change is not persisted until configureSystem
%   reads AssociatedBehaviorRigListBox.Items into app.Configuration.BehaviorRig and
%   writes system_conf_job_gui.json. Removing every rig leaves BehaviorRig empty,
%   which checkConfiguration treats as "not configured".
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - Button ButtonPushed event (unused)
%
%   Outputs:
%       None - Removes entries from app.AssociatedBehaviorRigListBox.Items
%
%   See also: addRig2System, configureSystem, startConfiguration, checkConfiguration

if ~isempty(app.AssociatedBehaviorRigListBox.Value)
    this_value = app.AssociatedBehaviorRigListBox.Value;
    idx_value = ismember(app.AssociatedBehaviorRigListBox.Items, this_value);
    app.AssociatedBehaviorRigListBox.Items(idx_value) = []; 
end

end