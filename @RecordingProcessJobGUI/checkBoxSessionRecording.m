
function checkBoxSessionRecording(app, event)

%Which objects are going to be enabled and which disabled
structEnables.Enable = {'BehaviorSessionDropDown'};
structEnables.Disable = {'RecordingSubjectDropDown', 'RecordingUserDropDown', 'RecordingDateDatePicker'};


if event.Source == app.IstherebehaviorSessionCheckBox
    %future code
    
    % Same code for _2 objects
elseif event.Source == app.IstherebehaviorSessionCheckBox_2
    structEnables.Enable = strcat(structEnables.Enable,'_2');
    structEnables.Disable = strcat(structEnables.Disable,'_2');
end

if event.Value == 0
    %Opposite things are enabled and disabled
    aux = structEnables.Enable;
    structEnables.Enable = structEnables.Disable;
    structEnables.Disable = aux;
end

app.controlEnables(structEnables);

end