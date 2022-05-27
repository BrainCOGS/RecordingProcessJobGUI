function updateBusyLabel(app, status)


if status
    app.BusyLabel.BackgroundColor     = app.OKColor;
    app.BusyLabel.Text                = 'Ready';
else
    app.BusyLabel.BackgroundColor     = app.ErrorColor;
    app.BusyLabel.Text                = 'Busy';

drawnow;

end

