
function filterTable(app, event)
%FILTERTABLE Rebuild the job or recording table from the filter widgets
%
%   Shared callback for every filter control on the "Manage Processing Jobs" and
%   "Recording Table" tabs. It switches on event.Source to work out which widget
%   fired, updates the matching filter struct, and re-fills the affected tables.
%
%   Two independent filters are kept, one per tab: app.FilterRecordingJob drives
%   fillJobTable (Tab 4, widgets app.UserDropDown, app.SubjectDropDown_2,
%   app.DateDatePicker, app.refreshFilterTableButton) and app.FilterRecordingRT
%   drives fillRecordingTable (Tab 3, widgets app.UserDropDownRT,
%   app.SubjectDropDownRT, app.DateDatePickerRT, app.refreshFilterTableButtonRT).
%
%   Note the filters are not cumulative in the same way across widgets. Picking a
%   user or a subject *resets* the filter struct to a single restriction, and
%   picking a user additionally repopulates the subject dropdown (via
%   fillRecordingSubject / fillRecordingSubjectRT) so it only offers that user's
%   subjects. Picking a date instead *adds* session_date to whatever restriction
%   is already there, so user/subject + date can be combined. The refresh buttons
%   clear the filter struct back to empty and reload everything unrestricted.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ValueChanged / ButtonPushed event;
%                                      event.Source identifies the widget and
%                                      event.Source.Value carries the new filter
%
%   Outputs:
%       None - Updates app.FilterRecordingJob or app.FilterRecordingRT and
%              re-fills app.JobTable or app.RecordingTableRT
%
%   Dependencies:
%       - fillJobTable, fillRecordingTable
%       - fillRecordingSubject, fillRecordingSubjectRT
%       - updateBusyLabel
%
%   See also: fillJobTable, fillRecordingTable, fillRecordingSubject, fillRecordingUser

updateBusyLabel(app, false);

switch event.Source
    
    %Recording Table
    case app.UserDropDown
        app.FilterRecordingJob = struct();
        app.FilterRecordingJob.user_id = event.Source.Value;
        fillRecordingSubject(app, app.FilterRecordingJob);
        fillJobTable(app, app.FilterRecordingJob);
               
    case app.SubjectDropDown_2
        app.FilterRecordingJob = struct();
        app.FilterRecordingJob.subject_fullname = event.Source.Value;
        fillJobTable(app, app.FilterRecordingJob);

     case app.DateDatePicker
        app.FilterRecordingJob.session_date = datestr(event.Source.Value, 'yyyy-mm-dd');  
        fillJobTable(app, app.FilterRecordingJob);
        
     case app.refreshFilterTableButton
        app.FilterRecordingJob = struct();
        fillRecordingSubject(app, app.FilterRecordingJob);
        fillJobTable(app, app.FilterRecordingJob);
        
        
        
     %RT Table   
     case app.UserDropDownRT
        app.FilterRecordingRT = struct();
        app.FilterRecordingRT.user_id = event.Source.Value;
        fillRecordingSubjectRT(app, app.FilterRecordingRT);
        fillRecordingTable(app, app.FilterRecordingRT);
               
    case app.SubjectDropDownRT
        app.FilterRecordingRT = struct();
        app.FilterRecordingRT.subject_fullname = event.Source.Value;
        fillRecordingTable(app, app.FilterRecordingRT);

     case app.DateDatePickerRT
        app.FilterRecordingRT.session_date = datestr(event.Source.Value, 'yyyy-mm-dd');  
        fillRecordingTable(app, app.FilterRecordingRT);
        
     case app.refreshFilterTableButtonRT
        app.FilterRecordingRT = struct();
        fillRecordingSubjectRT(app, app.FilterRecordingRT);
        fillRecordingTable(app, app.FilterRecordingRT);
        
end

updateBusyLabel(app, true);

end
    


