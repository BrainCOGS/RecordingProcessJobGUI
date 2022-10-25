
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


for i=1:app.AllSurgeryStuff.numDevices
    app.AllSurgeryStuff.devicesStruct(i).subject_fullname = app.AllSurgeryStuff.subjectEdit.Value;
    app.AllSurgeryStuff.devicesStruct(i).surgery_start_time = datestr(app.AllSurgeryStuff.datePicker.Value, 'YYYY-mm-dd');
end

conn = dj.conn();
conn.startTransaction();
try
    %Insert recording and then recordingProcess
    insert(action.Surgery, surgery_struct);
    if app.AllSurgeryStuff.numDevices > 0
        insert(action.SurgeryLocation, app.AllSurgeryStuff.devicesStruct);
    end
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


