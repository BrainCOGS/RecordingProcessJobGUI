
function closeSurgeryFigure(app, event)
%CLOSESURGERYFIGURE Dismiss the surgery dialog without writing anything
%
%   ButtonPushed callback for the Cancel button of the surgery sub-figure. Just
%   closes app.AllSurgeryStuff.surgeryFigure; nothing is inserted, and whatever was
%   collected in app.AllSurgeryStuff (devicesStruct, numDevices) is discarded with
%   the figure - contrast registerSurgery, which inserts first and then closes.
%
%   Closing the figure is what releases the uiwait that addSurgeryData is blocked
%   on, so this is how the user returns control to createRecording. Note that
%   createRecording does not check whether a surgery was actually registered, so
%   cancelling here means the recording is still created and the subject still has
%   no action.Surgery record.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - ButtonPushed event; unused
%
%   Outputs:
%       None - Closes app.AllSurgeryStuff.surgeryFigure and releases the uiwait in
%              addSurgeryData
%
%   See also: addSurgeryData, registerSurgery, createComponentsSurgeryFigure
close(app.AllSurgeryStuff.surgeryFigure)

end


