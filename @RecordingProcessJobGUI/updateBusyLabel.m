function updateBusyLabel(app, status)
%UPDATEBUSYLABEL Set the Busy/Ready indicator that tells the user the GUI is working
%
%   Paints app.BusyLabel, the status indicator shown outside any tab. Long operations
%   (database fetches, ROBOCOPY to cup, python calls) block MATLAB's single thread and
%   freeze the window, so every such method brackets itself with a call to this
%   function to show that the GUI is working rather than hung.
%
%   MIND THE POLARITY - status is "is the GUI ready?", NOT "is the GUI busy?":
%
%       updateBusyLabel(app, false)  ->  red   'Busy'   (call BEFORE the long work)
%       updateBusyLabel(app, true)   ->  green 'Ready'  (call AFTER the long work)
%
%   So the argument reads as the state you are moving INTO, and the value that
%   matches the function's name (busy) is the FALSE one. Callers pass it both ways -
%   updateBusyLabel(app, 0) / (app, 1) and (app, false) / (app, true) - which is the
%   same thing. Getting this backwards leaves the GUI showing 'Ready' for the whole
%   operation and 'Busy' forever afterwards.
%
%   The busy branch calls drawnow so the red label is actually painted before the
%   caller's blocking work starts; without it MATLAB would not flush the update until
%   the operation had already finished.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       status (logical)             - true/1 = ready (green 'Ready');
%                                      false/0 = busy (red 'Busy')
%
%   Outputs:
%       None - Sets app.BusyLabel.Text and app.BusyLabel.BackgroundColor
%              (app.OKColor when ready, app.ErrorColor when busy)
%
%   See also: startupFcn, configureSystem, startConfiguration


if status
    app.BusyLabel.BackgroundColor     = app.OKColor;
    app.BusyLabel.Text                = 'Ready';
else
    app.BusyLabel.BackgroundColor     = app.ErrorColor;
    app.BusyLabel.Text                = 'Busy';

drawnow;

end

