
function createRecording(app, event)

% Get all info to insert recording.Recording table
% ALS , modify when no behavior session is there %%%%%%%%%%%%%%%%%%%%%%%

% Get default parameters record (or records)
default_params_record = createDefaultParamsRecord(app);

%Filter behavior session
behavior_session = app.BehaviorSessions( ...
    matches(app.BehaviorSessions.session_name, app.BehaviorSessionDropDown.Value), :);

%Generate key for part table
key_part.subject_fullname    = behavior_session.subject_fullname{:};

%ALS, get user_id from behavior session merge
user_id = strsplit(key_part.subject_fullname,'_');
user_id = user_id{1};

key_part.session_date        = behavior_session.session_date{:};
key_part.session_number      = behavior_session.session_number;

session_date = [key_part.session_date(6:7) key_part.session_date(9:10) key_part.session_date(1:4)];

% Generate key for recording table
key.recording_modality  = app.Configuration.RecordingModality;
key.location            = app.Configuration.System;

local_directory         = fullfile(app.Configuration.RecordingRootDirectory, app.RecordingDirectoryDropDown.Value);
last_folder             = strsplit(local_directory,filesep);
last_folder             = last_folder{end};
%key.recording_directory = spec_fullfile('/', user_id, key_part.subject_fullname, session_date, [session_date '_g' num2str(key_part.session_number)], last_folder);
key.recording_directory = spec_fullfile('/', user_id, key_part.subject_fullname, session_date, last_folder);
key.local_directory     = local_directory; 
key.status_recording_id = 0;


%insert values
conn = dj.conn();
conn.startTransaction();
try
    %Insert recording and then recordingProcess 
    insert(recording.Recording, key);
    recording_id = fetch(recording.Recording, 'ORDER BY recording_id desc LIMIT 1');
    key_part.recording_id = recording_id.recording_id;
    [default_params_record.('recording_id')] = deal(recording_id.recording_id);
    %process_key.recording_id = key_part.recording_id;
    insert(recording.RecordingBehaviorSession, key_part);
    insert(recording.DefaultParams, default_params_record);
    conn.commitTransaction
    
    fillTable(app);
    fillRecordingUser(app);
    fillRecordingSubject(app);
    
    event.Source.Enable = 'on';
    updateBusyLabel(app, true);
    
    
    uiconfirm(app.UIFigure,'Recording was registered successfully', ...
    'Job Creation Success', ...
    'Options',{'OK'}, ...
    'Icon','success');

    app.PreParamSelectionTable = [];
    app.ParamSelectionTable = [];
    
    app.ListBoxFragmentRecordingPreParams.Items = {'0', '1', '2', '3', '4'};
    app.ListBoxFragmentRecording2Params.Items = {'0', '1', '2', '3', '4'};



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


