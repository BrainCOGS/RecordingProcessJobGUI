
function createRecordingButton(app, event)

updateBusyLabel(app, false);

%Check if local directory already in DB
local_directory       = fullfile(app.Configuration.RecordingRootDirectory, app.RecordingDirectoryDropDown.Value);
local_directory       = strrep(local_directory,'\','/');
query.local_directory = local_directory;
query.location        = app.Configuration.System;

recorded_previously = fetch(app.RecordingTable & query);

%Get behavior key
behavior_session = app.BehaviorSessions( ...
    matches(app.BehaviorSessions.session_name, app.BehaviorSessionDropDown.Value), :);

%QUery if behavior already in DB
query2.subject_fullname    = behavior_session.subject_fullname{:};
query2.session_date        = behavior_session.session_date{:};
query2.session_number      = behavior_session.session_number;

session_previously = fetch(recording.RecordingBehaviorSession & query2);

selection = 'OK';
if ~isempty(recorded_previously)
    selection = uiconfirm(app.UIFigure,{'Recording file (recording directory & system) already in DB', ...
        'Do you want to proceed  ?'},'Confirm recording',...
        'Icon','warning');
end
if selection == "OK" && ~isempty(session_previously)
    selection = uiconfirm(app.UIFigure,{'Behavior session recording already in DB', ...
        'Do you want to proceed  ?'},'Confirm recording',...
        'Icon','warning');
end

if selection == "OK"
    
    if app.DefaultParametersCheckBox.Value
        createRecording(app, event);
    else
        %Set everything to create a recording on param selection tab
        
        app.TabGroup.SelectedTab = app.SelectRecordingParametersTab;
        app.CreateProcessingJobButton2.Enable = 'on';
        app.CreateProcessingJobButton2.ButtonPushedFcn = createCallbackFcn(app, @checkParamSelection, true);
        app.CreateProcessingJobButton2.Text = 'Register Recording';
        
        app.SameParamsRecordingCheckBox.Enable = 'on';
        app.SamePreParamListRecordingCheckBox.Enable = 'on';
        
        app.CreateRecordingOrJob    = true;
        
        fillUserParams(app);
        fillParams2Select(app);
        
    end
end

end