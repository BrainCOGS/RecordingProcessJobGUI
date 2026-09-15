
function createRecording(app, event)
%CREATERECORDING Copy a recording to cup and insert it into recording.Recording
%
%   The centerpiece of the "Add Recording" flow. Assembles the recording.Recording
%   key from the Tab 1 form, ROBOCOPYs the local data directory to cup, and then
%   inserts Recording + its session part table + DefaultParams inside a single
%   DataJoint transaction. Called by createRecordingButton (default-params path)
%   or by checkParamSelection (hand-picked-params path).
%
%   Behavior vs no-behavior branch (app.IstherebehaviorSessionCheckBox):
%     - Checked: the part-table key is taken from the row of app.BehaviorSessions
%       matching app.BehaviorSessionDropDown.Value, giving subject_fullname,
%       session_date and session_number; user_id comes from the session. The row
%       is inserted into recording.RecordingBehaviorSession. session_date is
%       compacted to 'yyyymmdd' for the cup path.
%     - Unchecked: subject comes from app.RecordingSubjectDropDown, user_id is the
%       prefix of subject_fullname before the first '_', and the datetime is built
%       from app.RecordingDateDatePicker (date) plus app.RecordingDateTimePicker
%       (a uispinner holding an integer hour 0-24). A RANDOM number of minutes
%       (rand()*60) is added to that hour to produce recording_datetime, so the
%       key is unique per registration. The row goes into
%       recording.RecordingRecordingSession instead.
%
%   recording_directory (the cup-relative path) differs between the two:
%     - with behavior:    /<user_id>/<subject_fullname>/<yyyymmdd>_g<session_number>/<last_folder>
%     - without behavior: /<user_id>/<subject_fullname>/<yyyymmdd_HHMMSS>/<last_folder>
%   where <last_folder> is the leaf of the selected local directory. local_directory
%   is stored with forward slashes; the Windows-separator form is what is handed to
%   copyRecording.
%
%   status_recording_id is set to 2 directly: because this method already copies the
%   data to cup itself, statuses 0 (new) and 1 (copying) are skipped.
%
%   If app.SurgeryCheckBox is set and action.Surgery has no entry for the subject,
%   addSurgeryData is called first. On success the recording id is reported, the
%   Recording Table tab is refreshed and selected, and the param selection state
%   (app.PreParamSelectionTable / app.ParamSelectionTable and the fragment list
%   boxes) is reset. On any error inside the transaction it is cancelled, so a
%   failed insert never leaves a half-registered recording -- but the files copied
%   to cup are NOT rolled back.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - ButtonPushed event of the calling button;
%                                      only event.Source.Enable is used, to
%                                      re-enable the button on failure
%
%   Outputs:
%       None - Inserts recording.Recording, one of
%              recording.RecordingBehaviorSession / RecordingRecordingSession,
%              and recording.DefaultParams; copies the data directory to cup
%
%   Dependencies:
%       - DataJoint tables: recording.Recording, recording.RecordingBehaviorSession,
%         recording.RecordingRecordingSession, recording.DefaultParams,
%         action.Surgery; dj.conn transaction
%       - createDefaultParamsRecord, copyRecording, addSurgeryData, spec_fullfile,
%         fillRecordingTable, fillRecordingSubjectRT, fillRecordingUserRT,
%         updateBusyLabel
%       - ROBOCOPY (via copyRecording)
%
%   See also: createRecordingButton, createDefaultParamsRecord, copyRecording,
%             checkParamSelection

updateBusyLabel(app, false);

% Get default parameters record (or records)
default_params_record = createDefaultParamsRecord(app);

%Filter behavior session
if app.IstherebehaviorSessionCheckBox.Value
    behavior_session = app.BehaviorSessions( ...
        matches(app.BehaviorSessions.session_name, app.BehaviorSessionDropDown.Value), :);
    %Generate key for part table
    key_part.subject_fullname    = behavior_session.subject_fullname{:};
    user_id = behavior_session.user_id{:};
    key_part.session_date        = behavior_session.session_date{:};
    key_part.session_number      = behavior_session.session_number;
    session_date = [key_part.session_date(1:4) key_part.session_date(6:7) key_part.session_date(9:10)];

% If there is not associated behavior
else
    key_part.subject_fullname = app.RecordingSubjectDropDown.Value;
    user_id = strsplit(key_part.subject_fullname,'_');
    user_id = user_id{1};
    rec_date                  = datestr(app.RecordingDateDatePicker.Value,'yyyy-mm-dd');
    rec_time                  = app.RecordingDateTimePicker.Value;
    hour_rec = hours(rec_time);
    minutes_rec = minutes(rand()*60) ;
    rec_time = datestr(hour_rec+minutes_rec,' HH:MM:SS');

    key_part.recording_datetime = [rec_date rec_time];
    
    %For unified path recording
    rec_date2                 = datestr(app.RecordingDateDatePicker.Value,'yyyymmdd');
    rec_time2 = datestr(hour_rec+minutes_rec,'_HHMMSS');
    session_date = [rec_date2 rec_time2];
end


% Add surgery if needed
surgery_info = fetch(action.Surgery & key_part);
if app.SurgeryCheckBox.Value && isempty(surgery_info)
   addSurgeryData(app, key_part.subject_fullname, user_id, app.Configuration.RecordingModality);
end


% Generate key for recording table
key.recording_modality  = app.Configuration.RecordingModality;
key.location            = app.Configuration.System;


this_local_directory = app.RecordingDirectoryTable{...
    matches(app.RecordingDirectoryTable.rec_dir_dropdown, app.RecordingDirectoryDropDown.Value), 'full_recording_directory'};
this_local_directory = this_local_directory{:};
%this_local_directory         = fullfile(app.Configuration.RecordingRootDirectory, app.RecordingDirectoryDropDown.Value);
last_folder             = strsplit(this_local_directory,filesep);
last_folder             = last_folder{end};
%key.recording_directory = spec_fullfile('/', user_id, key_part.subject_fullname, session_date, [session_date '_g' num2str(key_part.session_number)], last_folder);
%Slight difference if there is behavior or not how is saved directory
if app.IstherebehaviorSessionCheckBox.Value
    key.recording_directory = spec_fullfile('/', user_id, key_part.subject_fullname, [session_date '_g' num2str(key_part.session_number)], last_folder);
else
    key.recording_directory = spec_fullfile('/', user_id, key_part.subject_fullname, session_date, last_folder);
end
if ispc
    key.local_directory     = strrep(this_local_directory,'\','/');
    this_recording_directory = strrep(key.recording_directory,'/','\');
else
    key.local_directory     = this_local_directory;
    this_recording_directory = key.recording_directory;
end
% With new method we already copy recording so we skip status 0 & 1
key.status_recording_id = 2;


% Copy recording directory from local machine to cup
try
    progressdlg = uiprogressdlg(app.UIFigure, 'Message','Copying session to cup Data directory. Be patient, no progress shown', 'Indeterminate','on');
    status = copyRecording(app, this_recording_directory, this_local_directory, key.recording_modality);
    close(progressdlg)
catch err
    status = -1;
    uiconfirm(app.UIFigure,['Recording was not created ' err.message], ...
        '', ...
        'Options',{'OK'}, ...
        'Icon','error');
    event.Source.Enable = 'on';
    updateBusyLabel(app, true);
end
%error(err.message);
if status ~= -1
    
    %insert values
    conn = dj.conn();
    conn.startTransaction();
    try
        %Insert recording and then recordingProcess
        insert(recording.Recording, key);
        recording_id = fetch(recording.Recording, 'ORDER BY recording_id desc LIMIT 1');
        key_part.recording_id = recording_id.recording_id;
        [default_params_record.('recording_id')] = deal(recording_id.recording_id);
        %If there is no preprocessing steps set to 0 (for imaging right now)
        if isempty(default_params_record.preprocess_param_steps_id)
            default_params_record.preprocess_param_steps_id = 0;
        end
        %process_key.recording_id = key_part.recording_id;
        if app.IstherebehaviorSessionCheckBox.Value
            insert(recording.RecordingBehaviorSession, key_part);
        else
            insert(recording.RecordingRecordingSession, key_part);
        end
        insert(recording.DefaultParams, default_params_record);
        conn.commitTransaction
        
        fillRecordingTable(app);
        fillRecordingSubjectRT(app);
        fillRecordingUserRT(app);
        app.TabGroup.SelectedTab = app.RecordingTableTab;
        
        updateBusyLabel(app, true);
        
        uiconfirm(app.UIFigure,['Recording was registered successfully with id: ' num2str(recording_id.recording_id)] , ...
            'Job Creation Success', ...
            'Options',{'OK'}, ...
            'Icon','success');
        
        app.PreParamSelectionTable = [];
        app.ParamSelectionTable = [];
        
        app.ListBoxFragmentRecordingPreParams.Items = {'0', '1', '2', '3', '4'};
        app.ListBoxFragmentRecording2Params.Items = {'0', '1', '2', '3', '4'};
        
        app.CreateProcessingJobButton2.Enable = 'off';
        
        
    catch err
        conn.cancelTransaction
        uiconfirm(app.UIFigure,['Recording was not created' err.message], ...
            '', ...
            'Options',{'OK'}, ...
            'Icon','error');
        event.Source.Enable = 'on';
        updateBusyLabel(app, true);
        %error(err.message);
    end
    
else
    %copyRecording returned -1 without throwing, so there is no err to report
    uiconfirm(app.UIFigure,'Recording was not created, copying the recording directory to cup failed', ...
        '', ...
        'Options',{'OK'}, ...
        'Icon','error');
    event.Source.Enable = 'on';
    updateBusyLabel(app, true);
end



