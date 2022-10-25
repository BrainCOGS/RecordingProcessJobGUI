function createComponentsSurgeryFigure(app)

% Create UIFigure and hide until all components are created

app.AllSurgeryStuff = struct();

app.AllSurgeryStuff.surgeryFigure = uifigure('WindowStyle','modal', 'Visible','off');
screenSize = get(groot,'ScreenSize');
percentage_screen = 60;
ratio = percentage_screen/100;
offset = (1-ratio)/2;

app.AllSurgeryStuff.surgeryFigure.Position = [screenSize(3)*offset screenSize(4)*offset ...
                         screenSize(3)*ratio screenSize(4)*ratio];
app.AllSurgeryStuff.surgeryFigure.Name = 'Add surgery data';

% Create GridLayout4
app.AllSurgeryStuff.GridLayoutSurgery = uigridlayout(app.AllSurgeryStuff.surgeryFigure);
app.AllSurgeryStuff.GridLayoutSurgery.ColumnWidth = {'0.2x', '1x', '1x', '1x', '1x', '0.2x'};
app.AllSurgeryStuff.GridLayoutSurgery.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '0.3x', '1x', '1x', '1x', '0.5x'};
app.AllSurgeryStuff.GridLayoutSurgery.ColumnSpacing = 1.5;
app.AllSurgeryStuff.GridLayoutSurgery.RowSpacing = 2.25;
app.AllSurgeryStuff.GridLayoutSurgery.Padding = [1.5 2.25 1.5 2.25];

% Create userLabel
app.AllSurgeryStuff.titleLabel = uilabel(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.titleLabel.FontSize = 24;
app.AllSurgeryStuff.titleLabel.FontWeight = 'bold';
app.AllSurgeryStuff.titleLabel.Layout.Row = 1;
app.AllSurgeryStuff.titleLabel.Layout.Column =  [1 5];
app.AllSurgeryStuff.titleLabel.HorizontalAlignment = 'center';
app.AllSurgeryStuff.titleLabel.Text = '-- Add surgery data for subject --';

% Create subjectLabel
app.AllSurgeryStuff.subjectLabel = uilabel(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.subjectLabel.FontWeight = 'bold';
app.AllSurgeryStuff.subjectLabel.FontSize = 14;
app.AllSurgeryStuff.subjectLabel.Layout.Row = 2;
app.AllSurgeryStuff.subjectLabel.Layout.Column =  [1 2];
app.AllSurgeryStuff.subjectLabel.HorizontalAlignment = 'right';
app.AllSurgeryStuff.subjectLabel.Text = 'Subject fullname: ';

% Create subjectEdit
app.AllSurgeryStuff.subjectEdit = uieditfield(app.AllSurgeryStuff.GridLayoutSurgery, 'text');
app.AllSurgeryStuff.subjectEdit.FontSize = 14;
app.AllSurgeryStuff.subjectEdit.FontWeight = 'bold';
app.AllSurgeryStuff.subjectEdit.Enable =  'off';
app.AllSurgeryStuff.subjectEdit.Layout.Row = 2;
app.AllSurgeryStuff.subjectEdit.Layout.Column = [3 5];

% Create userLabel
app.AllSurgeryStuff.userLabel = uilabel(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.userLabel.FontWeight = 'bold';
app.AllSurgeryStuff.userLabel.FontSize = 14;
app.AllSurgeryStuff.userLabel.Layout.Row = 3;
app.AllSurgeryStuff.userLabel.Layout.Column = [1 2];
app.AllSurgeryStuff.userLabel.HorizontalAlignment = 'right';
app.AllSurgeryStuff.userLabel.Text = 'Surgery user: ';

% Create userDrop
app.AllSurgeryStuff.userDrop = uidropdown(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.userDrop.FontSize = 14;
app.AllSurgeryStuff.userDrop.Layout.Row = 3;
app.AllSurgeryStuff.userDrop.Layout.Column = [3 5];


% Create datetLabel
app.AllSurgeryStuff.datetLabel = uilabel(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.datetLabel.FontWeight = 'bold';
app.AllSurgeryStuff.datetLabel.FontSize = 14;
app.AllSurgeryStuff.datetLabel.Layout.Row = 4;
app.AllSurgeryStuff.datetLabel.Layout.Column = [1 2];
app.AllSurgeryStuff.datetLabel.HorizontalAlignment = 'right';
app.AllSurgeryStuff.datetLabel.Text = 'Surgery date: ';

% Create datePicker
app.AllSurgeryStuff.datePicker = uidatepicker(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.datePicker.FontSize = 14;
app.AllSurgeryStuff.datePicker.Layout.Row = 4;
app.AllSurgeryStuff.datePicker.Layout.Column = [3 5];
app.AllSurgeryStuff.datePicker.Value = datetime("today");


% Create decviceLabel
app.AllSurgeryStuff.decviceLabel = uilabel(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.decviceLabel.FontWeight = 'bold';
app.AllSurgeryStuff.decviceLabel.FontSize = 14;
app.AllSurgeryStuff.decviceLabel.Layout.Row = 5;
app.AllSurgeryStuff.decviceLabel.Layout.Column = [1 2];
app.AllSurgeryStuff.decviceLabel.HorizontalAlignment = 'right';
app.AllSurgeryStuff.decviceLabel.Text = 'Device inserted: ';

% Create deviceDrop
app.AllSurgeryStuff.deviceDrop = uidropdown(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.deviceDrop.FontSize = 14;
app.AllSurgeryStuff.deviceDrop.Layout.Row = 5;
app.AllSurgeryStuff.deviceDrop.Layout.Column = [3 5];


% Create hemisphereLabel
app.AllSurgeryStuff.hemisphereLabel = uilabel(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.hemisphereLabel.FontWeight = 'bold';
app.AllSurgeryStuff.hemisphereLabel.FontSize = 14;
app.AllSurgeryStuff.hemisphereLabel.Layout.Row = 6;
app.AllSurgeryStuff.hemisphereLabel.Layout.Column = [1 2];
app.AllSurgeryStuff.hemisphereLabel.HorizontalAlignment = 'right';
app.AllSurgeryStuff.hemisphereLabel.Text = 'Hemisphere: ';


% Create hemisphereDrop
app.AllSurgeryStuff.hemisphereDrop = uidropdown(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.hemisphereDrop.FontSize = 14;
app.AllSurgeryStuff.hemisphereDrop.Layout.Row = 6;
app.AllSurgeryStuff.hemisphereDrop.Layout.Column = [3 5];
app.AllSurgeryStuff.hemisphereDrop.Items = {'Bilateral', 'L', 'R'};

% Create coordinatesLabel
app.AllSurgeryStuff.coordinatesLabel = uilabel(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.coordinatesLabel.FontWeight = 'bold';
app.AllSurgeryStuff.coordinatesLabel.FontSize = 14;
app.AllSurgeryStuff.coordinatesLabel.Layout.Row = 7;
app.AllSurgeryStuff.coordinatesLabel.Layout.Column = [1 2];
app.AllSurgeryStuff.coordinatesLabel.HorizontalAlignment = 'right';
app.AllSurgeryStuff.coordinatesLabel.Interpreter = 'html';
app.AllSurgeryStuff.coordinatesLabel.Text = 'Coordinates (ml - ap - depth): ??';
app.AllSurgeryStuff.coordinatesLabel.Tooltip = ...
    {'in mm from bregma:', 'depth = dv if all angles = 0'};


app.AllSurgeryStuff.mlPositionEdit = uieditfield(app.AllSurgeryStuff.GridLayoutSurgery, 'numeric');
app.AllSurgeryStuff.mlPositionEdit.FontSize = 14;
app.AllSurgeryStuff.mlPositionEdit.Layout.Row = 7;
app.AllSurgeryStuff.mlPositionEdit.Layout.Column = 3;

app.AllSurgeryStuff.apPositionEdit = uieditfield(app.AllSurgeryStuff.GridLayoutSurgery, 'numeric');
app.AllSurgeryStuff.apPositionEdit.FontSize = 14;
app.AllSurgeryStuff.apPositionEdit.Layout.Row = 7;
app.AllSurgeryStuff.apPositionEdit.Layout.Column = 4;

app.AllSurgeryStuff.depthPositionEdit = uieditfield(app.AllSurgeryStuff.GridLayoutSurgery, 'numeric');
app.AllSurgeryStuff.depthPositionEdit.FontSize = 14;
app.AllSurgeryStuff.depthPositionEdit.Layout.Row = 7;
app.AllSurgeryStuff.depthPositionEdit.Layout.Column = 5;

% Create anglesLabel
app.AllSurgeryStuff.anglesLabel = uilabel(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.anglesLabel.FontWeight = 'bold';
app.AllSurgeryStuff.anglesLabel.FontSize = 14;
app.AllSurgeryStuff.anglesLabel.Layout.Row = 8;
app.AllSurgeryStuff.anglesLabel.Layout.Column = [1 2];
app.AllSurgeryStuff.anglesLabel.HorizontalAlignment = 'right';
app.AllSurgeryStuff.anglesLabel.Text = 'Angles (theta - phi - rho): ??';
app.AllSurgeryStuff.anglesLabel.Tooltip = ...
    {'theta:(deg) - elevation - rotation about the ml-axis - w.r.t the z+ axis',...
     'phi: (deg) - azimuth - rotation about the dv-axis - w.r.t the x+ axis', ...
     'rho: (deg) - device angle rotation on itself'};

app.AllSurgeryStuff.thetaAngleEdit = uieditfield(app.AllSurgeryStuff.GridLayoutSurgery, 'numeric');
app.AllSurgeryStuff.thetaAngleEdit.FontSize = 14;
app.AllSurgeryStuff.thetaAngleEdit.Layout.Row = 8;
app.AllSurgeryStuff.thetaAngleEdit.Layout.Column = 3;

app.AllSurgeryStuff.phiAngleEdit = uieditfield(app.AllSurgeryStuff.GridLayoutSurgery, 'numeric');
app.AllSurgeryStuff.phiAngleEdit.FontSize = 14;
app.AllSurgeryStuff.phiAngleEdit.Layout.Row = 8;
app.AllSurgeryStuff.phiAngleEdit.Layout.Column = 4;

app.AllSurgeryStuff.rhoAngleEdit = uieditfield(app.AllSurgeryStuff.GridLayoutSurgery, 'numeric');
app.AllSurgeryStuff.rhoAngleEdit.FontSize = 14;
app.AllSurgeryStuff.rhoAngleEdit.Layout.Row = 8;
app.AllSurgeryStuff.rhoAngleEdit.Layout.Column = 5;


% Create AllSurgeryStuff.addDevice
app.AllSurgeryStuff.addDevice = uibutton(app.AllSurgeryStuff.GridLayoutSurgery, 'push');
app.AllSurgeryStuff.addDevice.FontSize = 14;
app.AllSurgeryStuff.addDevice.Layout.Row = 10;
app.AllSurgeryStuff.addDevice.Layout.Column = 5;
app.AllSurgeryStuff.addDevice.Text = 'Add insertion device';
app.AllSurgeryStuff.addDevice.ButtonPushedFcn = createCallbackFcn(app, @addInsertionDevice, true);

app.AllSurgeryStuff.devicesStruct = struct();
app.AllSurgeryStuff.numDevices = 0;

% Create AllSurgeryStuff.deleteDeviceList
app.AllSurgeryStuff.deleteDeviceList = uibutton(app.AllSurgeryStuff.GridLayoutSurgery, 'push');
app.AllSurgeryStuff.deleteDeviceList.FontSize = 14;
app.AllSurgeryStuff.deleteDeviceList.Layout.Row = 11;
app.AllSurgeryStuff.deleteDeviceList.Layout.Column = 5;
app.AllSurgeryStuff.deleteDeviceList.Text = 'Delete device list';
app.AllSurgeryStuff.deleteDeviceList.ButtonPushedFcn = createCallbackFcn(app, @deleteInsertionDevice, true);

% Create AllSurgeryStuff.okButton
app.AllSurgeryStuff.deviceList = uilistbox(app.AllSurgeryStuff.GridLayoutSurgery);
app.AllSurgeryStuff.deviceList.FontSize = 14;
app.AllSurgeryStuff.deviceList.Layout.Row = [10 11];
app.AllSurgeryStuff.deviceList.Layout.Column = [2 4];
app.AllSurgeryStuff.deviceList.Items = {};


% Create AllSurgeryStuff.okButton
app.AllSurgeryStuff.okButton = uibutton(app.AllSurgeryStuff.GridLayoutSurgery, 'push');
app.AllSurgeryStuff.okButton.BackgroundColor = app.GreenBColor;
app.AllSurgeryStuff.okButton.FontWeight = 'bold';
app.AllSurgeryStuff.okButton.FontSize = 16;
app.AllSurgeryStuff.okButton.Layout.Row = 12;
app.AllSurgeryStuff.okButton.Layout.Column = [4 5];
app.AllSurgeryStuff.okButton.Text = 'Register Surgery Data';
app.AllSurgeryStuff.okButton.ButtonPushedFcn = createCallbackFcn(app, @registerSurgery, true);


% Create AllSurgeryStuff.cancelButton
app.AllSurgeryStuff.cancelButton = uibutton(app.AllSurgeryStuff.GridLayoutSurgery, 'push');
app.AllSurgeryStuff.cancelButton.FontSize = 16;
app.AllSurgeryStuff.cancelButton.Layout.Row = 12;
app.AllSurgeryStuff.cancelButton.Layout.Column = [2 3];
app.AllSurgeryStuff.cancelButton.Text = 'Cancel';
app.AllSurgeryStuff.cancelButton.ButtonPushedFcn = createCallbackFcn(app, @closeSurgeryFigure, true);

movegui(app.AllSurgeryStuff.surgeryFigure, 'center')
app.AllSurgeryStuff.surgeryFigure.Visible = 'on';

end

