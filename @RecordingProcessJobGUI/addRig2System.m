
function addRig2System(app, event)

new_item = app.AssociatedBehaviorRigDropDown.Value;

if (sum(ismember(app.AssociatedBehaviorRigListBox.Items, new_item)) == 0)
    app.AssociatedBehaviorRigListBox.Items = [app.AssociatedBehaviorRigListBox.Items new_item];
end

end