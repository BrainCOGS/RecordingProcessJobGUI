
function registerSurgery(app, event)
%REGISTERSURGERY Insert the surgery and its implanted devices into the database
%
%   ButtonPushed callback for the green "Register Surgery Data" button of the
%   surgery sub-figure - the only place this dialog writes anything. Inserts into
%   exactly two tables inside one dj.conn transaction:
%     - action.Surgery, always: one row keyed by subject_fullname +
%       surgery_start_time.
%     - action.SurgeryLocation, only if app.AllSurgeryStuff.numDevices > 0: the
%       whole app.AllSurgeryStuff.devicesStruct array accumulated by
%       addInsertionDevice, inserted in a single call.
%   It does NOT touch recording.Recording - createRecording does that after
%   addSurgeryData's uiwait returns.
%
%   The action.Surgery row takes subject_fullname from the read-only subjectEdit,
%   surgery_start_time from datePicker (formatted 'YYYY-mm-dd', so the date only -
%   no time of day), and user_id from userDrop. The remaining three fields are
%   hardcoded because the GUI does not collect them: location is the literal string
%   'Surgery_room', surgery_outcome_type is always 'success', and surgery_type is
%   set to app.Configuration.RecordingModality ('electrophysiology' or 'imaging'),
%   i.e. it records the modality the rig is configured for rather than any real
%   surgical classification.
%
%   Before inserting, the loop over 1:numDevices stamps subject_fullname and
%   surgery_start_time onto every element of devicesStruct, since addInsertionDevice
%   only stores the per-device fields (device_idx, insertion_device_name,
%   hemisphere, real_ml/ap/depth_coordinates, phi/theta/rho_angle) and these two are
%   the foreign key back to action.Surgery.
%
%   On success the transaction commits and the figure is closed, which releases the
%   uiwait in addSurgeryData and lets createRecording carry on. On any error the
%   transaction is cancelled, an error uiconfirm is shown on app.UIFigure - so
%   nothing is half-written - and the figure is closed anyway: the surgery is lost
%   and the recording is still registered without it.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - ButtonPushed event; unused
%
%   Outputs:
%       None - Inserts one action.Surgery row and, if any devices were added,
%              app.AllSurgeryStuff.numDevices action.SurgeryLocation rows; closes
%              the surgery figure
%
%   Dependencies:
%       - DataJoint tables: action.Surgery, action.SurgeryLocation; dj.conn
%         transaction
%       - app.Configuration.RecordingModality (from checkConfiguration)
%
%   See also: addSurgeryData, addInsertionDevice, deleteInsertionDevice,
%             closeSurgeryFigure, createRecording


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


