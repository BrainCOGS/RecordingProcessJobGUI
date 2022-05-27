



key = struct();
key.recording_modality = 'electrophysiology';
key.modality_description = 'electrophysiology modality';
key.root_directory = '/braininit/Data/Raw/electrophysiology';
key.recording_file_extensions = {'ap.bin', 'ap.meta'};
key.recording_file_pattern  = {'/*g[0-9]/*imec[0-9]'};
key.process_unit_file_pattern = {'/*imec[0-9]/'};
key.process_unit_dir_fieldname = '';
key.process_repository = '';

insert(recording.RecordingModality, key);

key = struct();
key.recording_modality = 'imaging';
key.modality_description = 'imaging modality';
key.root_directory = '/braininit/Data/Raw/imaging';
key.recording_file_extensions = {'.avi', '.tiff','.tif'};
key.recording_file_pattern  = {''};
key.process_unit_file_pattern = {''};
key.process_unit_dir_fieldname = '';
key.process_repository = '';

insert(recording.RecordingModality, key);

key = struct();
key.recording_modality = 'video_acquisition';
key.modality_description = 'video_acquisition modality';
key.root_directory = '/braininit/Data/Raw/video_acquisition';
key.recording_file_extensions = {'.avi', '.mp4'};
key.recording_file_pattern  = {''};
key.process_unit_file_pattern = {''};
key.process_unit_dir_fieldname = '';
key.process_repository = '';

insert(recording.RecordingModality, key);


