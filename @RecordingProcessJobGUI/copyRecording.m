function status = copyRecording(app, bucket_rel_recording_directory, local_directory, recording_modality)
%copy recording directory from local machine to cup 

this_root_directory = app.RootDirectories.(recording_modality);

full_recording_dir = fullfile(this_root_directory, bucket_rel_recording_directory);

if ~isfloder(full_recording_dir)
    mkdir(full_recording_dir);
end

copy_command = ['ROBOCOPY ' local_directory full_recording_dir ' /E'];

[status,cmdout] = system(copy_command);



end

