function DefaultParamsCheckBoxToggle(app, event)

if app.DefaultParametersCheckBox.Value
    app.CreateProcessingJobButton.Text = 'Register Recording';
    app.CreateProcessingJobButton.BackgroundColor = app.GreenBColor;
else
    app.CreateProcessingJobButton.Text = 'Select parameters >>>';   
    app.CreateProcessingJobButton.BackgroundColor = app.YellowBColor;
end

end

