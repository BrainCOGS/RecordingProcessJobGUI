function DefaultParamsCheckBoxToggle(app, event)

if app.DefaultParametersCheckBox.Value
    app.CreateProcessingJobButton.Text = 'Register Recording';
else
    app.CreateProcessingJobButton.Text = 'Select parameters ->';    
end

end

