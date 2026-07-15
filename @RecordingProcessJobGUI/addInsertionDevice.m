
function addInsertionDevice(app, event)
%ADDINSERTIONDEVICE Append the current device/coordinate form to the device list
%
%   ButtonPushed callback for the "Add insertion device" button of the surgery
%   sub-figure. One surgery can implant several devices, so the dialog does not
%   write anything on its own: each press snapshots the current state of the
%   device / hemisphere / coordinate / angle controls into one element of
%   app.AllSurgeryStuff.devicesStruct and bumps app.AllSurgeryStuff.numDevices.
%   registerSurgery later inserts that whole struct array in one go, so a device
%   only counts if it was added here first - values merely typed into the form and
%   never added are silently dropped.
%
%   The struct element records device_idx (zero-based: numDevices-1),
%   insertion_device_name, hemisphere, real_ml_coordinates, real_ap_coordinates,
%   real_depth_coordinates (mm from bregma) and phi_angle / theta_angle /
%   rho_angle (degrees). These are exactly the action.SurgeryLocation fields;
%   subject_fullname and surgery_start_time are filled in later by registerSurgery.
%
%   It also pushes a human-readable row onto app.AllSurgeryStuff.deviceList of the
%   form 'device idx: <n>  _  <device name>  _  <ml>-<ap>-<depth>' (coordinates to
%   one decimal), which is the only feedback the user gets that the add worked.
%   Note the form controls are not cleared, so adding a second device means editing
%   the fields that differ and pressing the button again.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - ButtonPushed event; unused
%
%   Outputs:
%       None - Appends to app.AllSurgeryStuff.devicesStruct, increments
%              app.AllSurgeryStuff.numDevices and adds an item to
%              app.AllSurgeryStuff.deviceList
%
%   See also: createComponentsSurgeryFigure, deleteInsertionDevice,
%             registerSurgery, addSurgeryData

app.AllSurgeryStuff.numDevices = app.AllSurgeryStuff.numDevices + 1;
device_idx = app.AllSurgeryStuff.numDevices;


app.AllSurgeryStuff.devicesStruct(device_idx).device_idx = device_idx-1;
app.AllSurgeryStuff.devicesStruct(device_idx).insertion_device_name = app.AllSurgeryStuff.deviceDrop.Value;
app.AllSurgeryStuff.devicesStruct(device_idx).hemisphere = app.AllSurgeryStuff.hemisphereDrop.Value;
app.AllSurgeryStuff.devicesStruct(device_idx).real_ml_coordinates = app.AllSurgeryStuff.mlPositionEdit.Value;
app.AllSurgeryStuff.devicesStruct(device_idx).real_ap_coordinates = app.AllSurgeryStuff.apPositionEdit.Value;
app.AllSurgeryStuff.devicesStruct(device_idx).real_depth_coordinates = app.AllSurgeryStuff.depthPositionEdit.Value;
app.AllSurgeryStuff.devicesStruct(device_idx).phi_angle = app.AllSurgeryStuff.phiAngleEdit.Value;
app.AllSurgeryStuff.devicesStruct(device_idx).theta_angle = app.AllSurgeryStuff.thetaAngleEdit.Value;
app.AllSurgeryStuff.devicesStruct(device_idx).rho_angle = app.AllSurgeryStuff.rhoAngleEdit.Value;


coord_label = [num2str(app.AllSurgeryStuff.mlPositionEdit.Value,'%1.1f'), '-' ...
              num2str(app.AllSurgeryStuff.apPositionEdit.Value,'%1.1f'), '-' ...
              num2str(app.AllSurgeryStuff.depthPositionEdit.Value,'%1.1f')];
itemlabel = ['device idx: ' num2str(device_idx-1) '  _  ' app.AllSurgeryStuff.deviceDrop.Value '  _  ' coord_label];

app.AllSurgeryStuff.deviceList.Items = [app.AllSurgeryStuff.deviceList.Items {itemlabel}];


end


