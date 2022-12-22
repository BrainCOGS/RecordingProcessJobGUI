
function checkBoxSessionRecording(app, event)

%Which objects are going to be enabled and which disabled
structEnables.Enable = {'BehaviorSessionDropDown', 'BehaviorSessionDropDownLabel'};
structEnables.Disable = {'RecordingSubjectDropDown', 'RecordingDateDatePicker', 'RecordingDateTimePicker', ...
                         'RecordingSubjectDropDownLabel', 'RecordingDateDatePickerLabel', 'RecordingDateTimePickerLabel'};


                     
if event.Value == 0
    %Opposite things are enabled and disabled
    aux = structEnables.Enable;
    structEnables.Enable = structEnables.Disable;
    structEnables.Disable = aux;
    
    if app.first_time_not_behavior == 0
        app.first_time_not_behavior = 1;
        app.fillSubjects()
        %app.fillRecordingUser
    end
end

app.controlEnables(structEnables);

end