
function dropRig2System(app, event)

if ~isempty(app.AssociatedBehaviorRigListBox.Value)
    this_value = app.AssociatedBehaviorRigListBox.Value;
    idx_value = ismember(app.AssociatedBehaviorRigListBox.Items, this_value);
    app.AssociatedBehaviorRigListBox.Items(idx_value) = []; 
end

end