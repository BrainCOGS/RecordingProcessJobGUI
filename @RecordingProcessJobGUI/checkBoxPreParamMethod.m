
function checkBoxPreParamMethod(app, event)

if app.NewPreParamMethodCheckBox.Value
    app.CreatePreParamSetMethodsDropLabel.Enable = 'off';
    app.CreatePreParamSetMethodsDrop.Enable = 'off';
    app.NewPreParamMethodLabel.Enable = 'on';
    app.NewPreParamMethodEdit.Enable = 'on';
else
    app.CreatePreParamSetMethodsDropLabel.Enable = 'on';
    app.CreatePreParamSetMethodsDrop.Enable = 'on';
    app.NewPreParamMethodLabel.Enable = 'off';
    app.NewPreParamMethodEdit.Enable = 'off';
end
    
end