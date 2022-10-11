
function addSurgeryData(app, subject_fullname, user_id, modality)


createComponentsSurgeryFigure(app);

app.AllSurgeryStuff.subjectEdit.Value = subject_fullname;

users = fetchn(lab.User,'user_id');
app.AllSurgeryStuff.userDrop.Items = users;
app.AllSurgeryStuff.userDrop.Value = users{ismember(users, user_id)};

app.AllSurgeryStuff.deviceDrop.Items = fetchn(lab.InsertionDevice, 'insertion_device_name');

uiwait(app.AllSurgeryStuff.surgeryFigure);

end


