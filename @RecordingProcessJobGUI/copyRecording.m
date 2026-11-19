function status = copyRecording(app, bucket_rel_recording_directory, local_directory, recording_modality)
%COPYRECORDING Move recording files from the local machine to cup
%
%   Moves the raw data onto the lab's network storage before the
%   recording is registered, which is why createRecording can skip straight to
%   status_recording_id = 2. The destination root is looked up per modality in
%   app.RootDirectories.(recording_modality) and joined with the cup-relative
%   recording_directory built by createRecording; the folder is created if it does
%   not exist. ROBOCOPY /E includes empty subdirectories and /MOV removes
%   each source file after it is copied. Windows only.
%
%   Inputs:
%       app (RecordingProcessJobGUI)      - The GUI application object
%       bucket_rel_recording_directory    - Cup-relative destination path, with the
%                                           platform's separators
%       local_directory                   - Full path of the local source directory
%       recording_modality                - 'electrophysiology' or 'imaging'; keys
%                                           into app.RootDirectories
%
%   Outputs:
%       status - 1 if files were moved, 3 if files were moved and the
%                destination also contained extra files, or -1 on failure.
%
%   Dependencies:
%       - ROBOCOPY (Windows)
%       - app.RootDirectories, populated from the modality configuration
%
%   See also: createRecording, spec_fullfile

this_root_directory = app.RootDirectories.(recording_modality);

full_recording_dir = fullfile(this_root_directory, bucket_rel_recording_directory);

if ~isfolder(full_recording_dir)
    mkdir(full_recording_dir);
end

% Include matching and attribute-only differences so a retry can move files
% that would otherwise be skipped because a copy already exists on cup.
move_command = sprintf('ROBOCOPY "%s" "%s" /E /MOV /IS /IT', ...
    local_directory, full_recording_dir);

[status, ~] = system(move_command);

if status ~= 1 && status ~= 3
    status = -1;
end



end

