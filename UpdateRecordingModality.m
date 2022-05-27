
key.recording_modality = 'electrophysiology';
value = {'ap.bin', 'ap.meta'};
update(recording.RecordingModality &  key, 'recording_file_extensions',value)
value = {'/*g[0-9]/*imec[0-9]'};
update(recording.RecordingModality &  key, 'recording_file_pattern',value)
value = {'/*imec[0-9]/'};
update(recording.RecordingModality &  key, 'process_unit_file_pattern',value)

key.recording_modality = 'imaging';
value = {'.avi', '.tiff','.tif'};
update(recording.RecordingModality &  key, 'recording_file_extensions',value)
value = {''};
update(recording.RecordingModality &  key, 'recording_file_pattern',value)
value = {''};
update(recording.RecordingModality &  key, 'process_unit_file_pattern',value)

key.recording_modality = 'video_acquisition';
value = {'.avi', '.mp4'};
update(recording.RecordingModality &  key, 'recording_file_extensions',value)
value = {''};
update(recording.RecordingModality &  key, 'recording_file_pattern',value)
value = {''};
update(recording.RecordingModality &  key, 'process_unit_file_pattern',value)
