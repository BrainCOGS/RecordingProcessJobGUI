
function addSurgeryData(app, subject_fullname, user_id, modality)


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


