
function registerSurgery(app, event)
% Write surgery and surgery location


surgery_struct = struct();
surgery_struct.subject_fullname = app.AllSurgeryStuff.subjectEdit.Value;
surgery_struct.surgery_start_time = datestr(app.AllSurgeryStuff.datePicker.Value, 'YYYY-mm-dd');
surgery_struct.user_id = app.AllSurgeryStuff.userDrop.Value;

% Hardcoded unused data for surgeries
surgery_struct.location = 'Surgery_room';
surgery_struct.surgery_type =  app.Configuration.RecordingModality;
surgery_struct.surgery_outcome_type = 'success';

surgery_location_struct = struct();
surgery_location_struct.subject_fullname = app.AllSurgeryStuff.subjectEdit.Value;
surgery_location_struct.surgery_start_time = datestr(app.AllSurgeryStuff.datePicker.Value, 'YYYY-mm-dd');
surgery_location_struct.device_idx = 0;
surgery_location_struct.insertion_device_name = app.AllSurgeryStuff.deviceDrop.Value;
surgery_location_struct.hemisphere = app.AllSurgeryStuff.hemisphereDrop.Value;
surgery_location_struct.real_ml_coordinates = app.AllSurgeryStuff.mlPositionEdit.Value;
surgery_location_struct.real_ap_coordinates = app.AllSurgeryStuff.apPositionEdit.Value;
surgery_location_struct.real_dv_coordinates = app.AllSurgeryStuff.dvPositionEdit.Value;
surgery_location_struct.phi_angle = app.AllSurgeryStuff.phiAngleEdit.Value;
surgery_location_struct.theta_angle = app.AllSurgeryStuff.thetaAngleEdit.Value;


conn = dj.conn();
conn.startTransaction();
try
    %Insert recording and then recordingProcess
    insert(action.Surgery, surgery_struct);
    insert(action.SurgeryLocation, surgery_location_struct);
    conn.commitTransaction
    close(app.AllSurgeryStuff.surgeryFigure);
catch err
    conn.cancelTransaction
    uiconfirm(app.UIFigure,['Surgery data could not be registered' err.message], ...
        '', ...
        'Options',{'OK'}, ...
        'Icon','error');
    close(app.AllSurgeryStuff.surgeryFigure);
end











end


