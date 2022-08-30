
setenv('DB_PREFIX', 'u19_')
setenv('DB_PREFIX_TEST', 'u19_')
%connect_tech();

%UpdateRecordingModality;


clear key
 key.recording_modality = 'electrophysiology';
 key.process_paramset_desc = 'kilosort params';
 key.process_paramset = loadJSONfile('kilosort_params.json');
 
 
 try
     try_insert(recording.ProcessParamSet, key);
 catch ME
     ME.message
 end


clear key
key.recording_modality = 'imaging';
key.process_paramset_desc = 'suite2p params';
key.process_paramset = loadJSONfile('suite2p_params.json');

try
    try_insert(recording.ProcessParamSet, key);
catch ME
    ME.message
end

clear key
key.recording_modality = 'imaging';
key.process_paramset_desc = 'caiman params';
key.process_paramset = loadJSONfile('caiman_params.json');

try
    try_insert(recording.ProcessParamSet, key);
catch ME
    ME.message
end




clear key
key.recording_modality = 'imaging';
key.preprocess_paramset_desc = 'caiman load';
key.preprocess_paramset = loadJSONfile('caiman_load.json');

try
    try_insert(recording.PreprocessParamSet, key);
catch ME
    ME.message
end

clear key
key.recording_modality = 'imaging';
key.preprocess_paramset_desc = 'caiman trigger';
key.preprocess_paramset = loadJSONfile('caiman_trigger.json');

try
    try_insert(recording.PreprocessParamSet, key);
catch ME
    ME.message
end

 
clear key
key.recording_modality = 'imaging';
key.preprocess_paramset_desc = 'suite2p load';
key.preprocess_paramset = loadJSONfile('suite2p_load.json');

try
    try_insert(recording.PreprocessParamSet, key);
catch ME
    ME.message
end

clear key
key.recording_modality = 'imaging';
key.preprocess_paramset_desc = 'suite2p trigger';
key.preprocess_paramset = loadJSONfile('suite2p_trigger.json');

try
    try_insert(recording.PreprocessParamSet, key);
catch ME
    ME.message
end




clear key
key.recording_modality = 'electrophysiology';
key.preprocess_paramset_desc = 'tiger kilosort';
key.preprocess_paramset = loadJSONfile('tiger_kilosort.json');

try
    try_insert(recording.PreprocessParamSet, key);
catch ME
    ME.message
end



key = struct;
key.preprocess_paramset_idx = 1;
value = loadJSONfile('caiman_load.json');
update(recording.PreprocessParamSet &  key, 'preprocess_paramset',value);

key = struct;
key.preprocess_paramset_idx = 2;
value = loadJSONfile('caiman_trigger.json');
update(recording.PreprocessParamSet &  key, 'preprocess_paramset',value);


key = struct;
key.preprocess_paramset_idx = 3;
value = loadJSONfile('suite2p_load.json');
update(recording.PreprocessParamSet &  key, 'preprocess_paramset',value);


key = struct;
key.preprocess_paramset_idx = 4;
value = loadJSONfile('suite2p_trigger.json');
update(recording.PreprocessParamSet &  key, 'preprocess_paramset',value);


key = struct;
key.preprocess_paramset_idx = 5;
value = loadJSONfile('tiger_kilosort.json');
update(recording.PreprocessParamSet &  key, 'preprocess_paramset',value);



key = struct;
key.process_paramset_idx = 2;
value = loadJSONfile('suite2p_params.json');
update(recording.ProcessParamSet &  key, 'process_paramset',value);


key = struct;
key.process_paramset_idx = 3;
value = loadJSONfile('caiman_params.json');
update(recording.ProcessParamSet &  key, 'process_paramset',value);




clear key
key.recording_modality = 'electrophysiology';
key.preprocess_paramset_desc = 'cat_gt complete params';
key.preprocess_paramset = loadJSONfile('preprocess_paramset_29.json');

try
    try_insert(recording.PreprocessParamSet, key);
catch ME
    ME.message
end



clear key
key.recording_modality = 'electrophysiology';
key.preprocess_paramset_desc = 'cat_gt complete params 2';
key.preprocess_paramset = loadJSONfile('preprocess_paramset_29.json');

try
    try_insert(recording.PreprocessParamSet, key);
catch ME
    ME.message
end

