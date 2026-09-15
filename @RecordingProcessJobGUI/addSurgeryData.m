
function addSurgeryData(app, subject_fullname, user_id, modality)
%ADDSURGERYDATA Raise the modal surgery dialog and block until it is dismissed
%
%   Entry point of the surgery sub-figure. createRecording calls this from the Add
%   Recording tab when app.SurgeryCheckBox is ticked AND fetch(action.Surgery &
%   key_part) comes back empty, i.e. the subject has no surgery record yet and one
%   must be collected before the recording is registered.
%
%   Builds the dialog via createComponentsSurgeryFigure (which creates the whole
%   app.AllSurgeryStuff struct and makes the figure visible), then pre-fills the
%   three controls that can be seeded from the DB and the caller:
%     - subjectEdit is set to subject_fullname and left disabled (read-only).
%     - userDrop is filled with every user_id in lab.User and pre-selected to the
%       user_id passed in - the user of the behavior session, or the prefix of the
%       subject name when there is no behavior session.
%     - deviceDrop is filled from lab.InsertionDevice and pre-selected to
%       app.DefaultImplantationDevice.(modality) - 'NeuroPixel_Probe_v1' for
%       electrophysiology, 'no_device' for imaging (see configParams). If that
%       device is not in the table the dropdown is left on its first item.
%
%   The final uiwait blocks the caller on the figure until registerSurgery (which
%   inserts and closes) or closeSurgeryFigure / the Cancel button deletes it. Note
%   that createRecording does not check whether anything was actually registered:
%   cancelling simply lets the recording be created without a surgery record.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       subject_fullname             - Subject the surgery belongs to; shown
%                                      read-only and used as the insert key
%       user_id                      - lab.User to pre-select as the surgery user
%       modality                     - 'electrophysiology' or 'imaging'; keys into
%                                      app.DefaultImplantationDevice
%
%   Outputs:
%       None - Populates app.AllSurgeryStuff and blocks on uiwait until the
%              surgery figure is closed
%
%   Dependencies:
%       - DataJoint tables: lab.User, lab.InsertionDevice
%       - createComponentsSurgeryFigure, configParams (sets
%         app.DefaultImplantationDevice)
%
%   See also: createComponentsSurgeryFigure, registerSurgery, closeSurgeryFigure,
%             createRecording


createComponentsSurgeryFigure(app);

app.AllSurgeryStuff.subjectEdit.Value = subject_fullname;

users = fetchn(lab.User,'user_id');
app.AllSurgeryStuff.userDrop.Items = users;
app.AllSurgeryStuff.userDrop.Value = users{ismember(users, user_id)};

app.AllSurgeryStuff.deviceDrop.Items = fetchn(lab.InsertionDevice, 'insertion_device_name');
default_device = app.DefaultImplantationDevice.(modality);
idx_devicelist = find(ismember(app.AllSurgeryStuff.deviceDrop.Items, default_device));
if ~isempty(idx_devicelist)
    app.AllSurgeryStuff.deviceDrop.Value = app.AllSurgeryStuff.deviceDrop.Items(idx_devicelist);
end


uiwait(app.AllSurgeryStuff.surgeryFigure);

end


