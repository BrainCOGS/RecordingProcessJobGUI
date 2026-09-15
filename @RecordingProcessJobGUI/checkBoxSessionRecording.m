
function checkBoxSessionRecording(app, event)
%CHECKBOXSESSIONRECORDING Swap the Add Recording form between behavior and no-behavior
%
%   ValueChanged callback for app.IstherebehaviorSessionCheckBox. A recording is
%   normally tied to a behavior session, in which case only the session dropdown is
%   needed; if there is no behavior, the subject and the recording date/hour must be
%   entered by hand instead. This toggles which of the two input sets is live.
%
%   Checked (event.Value == 1): BehaviorSessionDropDown (+ its label) enabled, the
%   RecordingSubjectDropDown / RecordingDateDatePicker / RecordingDateTimePicker
%   trio (+ labels) disabled. Unchecked: the two lists are swapped, and the first
%   time the no-behavior path is used (app.first_time_not_behavior == 0) the subject
%   dropdown is populated by fillSubjects -- it is deferred until then because the
%   subject list is an expensive DataJoint fetch that most users never need.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - CheckBox ValueChanged event; event.Value is
%                                      1 when there IS a behavior session
%
%   Outputs:
%       None - Enables/disables Tab 1 components and may set
%              app.first_time_not_behavior and fill the subject dropdown
%
%   Dependencies:
%       - controlEnables, fillSubjects
%
%   See also: controlEnables, fillSubjects, createRecording

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