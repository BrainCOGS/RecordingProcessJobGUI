
function deleteInsertionDevice(app, event)
%DELETEINSERTIONDEVICE Clear every device accumulated on the surgery dialog
%
%   ButtonPushed callback for the "Delete device list" button of the surgery
%   sub-figure. Despite the singular name it does not remove the selected entry:
%   it wipes the whole list, resetting app.AllSurgeryStuff.numDevices to 0,
%   app.AllSurgeryStuff.devicesStruct to an empty struct() and
%   app.AllSurgeryStuff.deviceList.Items to {} - exactly the state
%   createComponentsSurgeryFigure starts from. There is no confirmation prompt and
%   no undo, so a mistyped fourth device costs all four.
%
%   The three fields are reset together on purpose: registerSurgery loops
%   1:numDevices over devicesStruct, so the counter and the struct array must not
%   drift apart. Nothing is written to the database here - the surgery form itself
%   (subject, user, date) is untouched, and the device form controls keep their
%   current values.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - ButtonPushed event; unused
%
%   Outputs:
%       None - Resets app.AllSurgeryStuff.numDevices, .devicesStruct and
%              .deviceList.Items
%
%   See also: addInsertionDevice, createComponentsSurgeryFigure, registerSurgery

app.AllSurgeryStuff.numDevices = 0;
app.AllSurgeryStuff.devicesStruct = struct();
app.AllSurgeryStuff.deviceList.Items = {};


end


