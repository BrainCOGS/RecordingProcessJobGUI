function status = copyRecording(app, bucket_rel_recording_directory, local_directory, recording_modality)
%COPYRECORDING Copy a recording directory from the local machine to cup
%
%   Mirrors the raw data directory onto the lab's network storage before the
%   recording is registered, which is why createRecording can skip straight to
%   status_recording_id = 2. The destination root is looked up per modality in
%   app.RootDirectories.(recording_modality) and joined with the cup-relative
%   recording_directory built by createRecording; the folder is created if it does
%   not exist. The copy itself is a blocking `ROBOCOPY <src> <dst> /E` shell call
%   (/E = include subdirectories, including empty ones). Windows only.
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
%       status - ROBOCOPY exit code if it equals 1 (files were copied), otherwise
%                -1. createRecording treats -1 as failure and aborts.
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

copy_command = ['ROBOCOPY ' local_directory ' ' full_recording_dir ' /E'];

[status,cmdout] = system(copy_command);

if status ~= 1
    status = -1;
end



end

