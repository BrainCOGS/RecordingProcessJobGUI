
function addInsertionDevice(app, event)
% Write surgery and surgery location

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


