
function filterTable(app, event)

updateBusyLabel(app, false);

switch event.Source
    
    %Recording Table
    case app.UserDropDown
        app.FilterRecordingJob = struct();
        app.FilterRecordingJob.user_id = event.Source.Value;
        fillRecordingSubject(app, app.FilterRecordingJob);
        fillTable(app, app.FilterRecordingJob);
               
    case app.SubjectDropDown_2
        app.FilterRecordingJob = struct();
        app.FilterRecordingJob.subject_fullname = event.Source.Value;
        fillTable(app, app.FilterRecordingJob);

     case app.DateDatePicker
        app.FilterRecordingJob.session_date = datestr(event.Source.Value, 'yyyy-mm-dd');  
        fillTable(app, app.FilterRecordingJob);
        
     case app.refreshFilterTableButton
        app.FilterRecordingJob = struct();
        fillRecordingSubject(app, app.FilterRecordingJob);
        fillTable(app, app.FilterRecordingJob);
        
        
        
     %RT Table   
     case app.UserDropDownRT
        app.FilterRecordingRT = struct();
        app.FilterRecordingRT.user_id = event.Source.Value;
        fillRecordingSubjectRT(app, app.FilterRecordingRT);
        fillTableRT(app, app.FilterRecordingRT);
               
    case app.SubjectDropDownRT
        app.FilterRecordingRT = struct();
        app.FilterRecordingRT.subject_fullname = event.Source.Value;
        fillTableRT(app, app.FilterRecordingRT);

     case app.DateDatePickerRT
        app.FilterRecordingRT.session_date = datestr(event.Source.Value, 'yyyy-mm-dd');  
        fillTableRT(app, app.FilterRecordingRT);
        
     case app.refreshFilterTableButtonRT
        app.FilterRecordingRT = struct();
        fillRecordingSubjectRT(app, app.FilterRecordingJob);
        fillTableRT(app, app.FilterRecordingRT);
        
end

updateBusyLabel(app, true);

end
    


