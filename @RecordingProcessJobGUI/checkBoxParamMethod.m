
function checkBoxParamMethod(app, event)

if app.NewParamMethodCheckBox.Value
    app.CreateParamSetMethodsDropLabel.Enable = 'off';
    app.CreateParamSetMethodsDrop.Enable = 'off';
    app.NewParamMethodLabel.Enable = 'on';
    app.NewParamMethodEdit.Enable = 'on';
else
    app.CreateParamSetMethodsDropLabel.Enable = 'on';
    app.CreateParamSetMethodsDrop.Enable = 'on';
    app.NewParamMethodLabel.Enable = 'off';
    app.NewParamMethodEdit.Enable = 'off';
end
    
end