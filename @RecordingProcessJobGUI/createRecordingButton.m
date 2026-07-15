
function createRecordingButton(app, event)
%CREATERECORDINGBUTTON Validate the Add Recording form and register or branch to params
%
%   ButtonPushed callback for app.CreateProcessingJobButton (Tab 1 "Add
%   Recording"). Runs the pre-flight checks before anything is written to the
%   database, then dispatches on the "Default Parameters" checkbox.
%
%   Three warnings can be raised, each as an uiconfirm the user must accept:
%     1. checkLocaldirSessionMatch says the subject nickname / date parsed out of
%        the local recording directory do not match the selected behavior session.
%     2. The (local_directory, location) pair is already in recording.Recording.
%     3. The selected (subject_fullname, session_date, session_number) is already
%        in recording.RecordingBehaviorSession.
%   Any answer other than "OK" aborts silently. Note that the paths are normalized
%   to forward slashes before querying, because that is how they are stored.
%
%   If the user confirms:
%     - DefaultParametersCheckBox checked  -> calls createRecording directly, which
%       copies to cup and inserts the recording using the modality's default
%       paramset / pre-process step list.
%     - unchecked -> does not insert anything. Instead it switches to
%       app.SelectRecordingParametersTab, sets app.CreateRecordingOrJob = true (so
%       the params tab knows it is finishing a *recording*, not a job), repoints
%       app.CreateProcessingJobButton2 at @checkParamSelection with the text
%       'Register Recording', enables the Same(Pre)Params checkboxes and populates
%       the param pickers via fillUserParams / fillParams2Select. createRecording
%       is then called from checkParamSelection.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - ButtonPushed event, forwarded to
%                                      createRecording (which uses event.Source
%                                      to re-enable the button on failure)
%
%   Outputs:
%       None - Either registers the recording or arms the Select Parameters tab
%
%   Dependencies:
%       - DataJoint tables: recording.Recording (via app.RecordingTable),
%         recording.RecordingBehaviorSession
%       - checkLocaldirSessionMatch, createRecording, fillUserParams,
%         fillParams2Select, updateBusyLabel
%
%   See also: createRecording, checkParamSelection, checkLocaldirSessionMatch,
%             DefaultParamsCheckBoxToggle

updateBusyLabel(app, false);

%Check if local directory already in DB

local_directory = app.RecordingDirectoryTable{...
    matches(app.RecordingDirectoryTable.rec_dir_dropdown, app.RecordingDirectoryDropDown.Value), 'full_recording_directory'};
local_directory = local_directory{:};
%local_directory       = fullfile(app.Configuration.RecordingRootDirectory, app.RecordingDirectoryDropDown.Value);
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

%Check if probable match betwen local dir and session data
dir_session_match = checkLocaldirSessionMatch(app, local_directory, query2.subject_fullname, query2.session_date);


selection = "OK";
if ~dir_session_match
  selection = uiconfirm(app.UIFigure,{'Subject fullname and/or session date does not appear to match between local dir and session data',...
      [newline, 'local_dir: ', local_directory, newline], ...
      ['session_data: ', query2.subject_fullname, ' ', query2.session_date newline], ...
      'Do you want to proceed?'},'Confirm recording',...
        'Icon','warning');
end
if selection == "OK" && ~isempty(recorded_previously)
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

updateBusyLabel(app, true);


end