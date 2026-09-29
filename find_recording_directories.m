function rec_dirs = find_recording_directories(root_dir, patterns)
%FIND_RECORDING_DIRECTORIES List the folders under a root that hold raw recording files
%
%   Builds the candidate list behind the Add Recording tab's Recording Directory
%   dropdown. Walks every folder under root_dir (any depth) with dirwalk/visitor2
%   and keeps each folder that directly contains a file whose name matches one of
%   the regexps in patterns. root_dir itself is never returned, even if it holds
%   matching files.
%
%   Every hit that sits inside another hit is dropped, so a recording is listed
%   once at its top folder: for ephys a SpikeGLX gate folder (run_g0/, holding
%   the nidq file) and not its probe subfolders (run_g0_imec0/, ...); for
%   imaging a session folder (09022026/) and not the subfolders the pipeline
%   writes below it (originalStacks/, splits, ...). Nesting is decided on whole
%   path components, so a sibling that only shares a name prefix
%   (09022026_round2/, rec10/) is always listed on its own.
%
%   Inputs:
%       root_dir (char/string) - Recording root directory to walk
%       patterns (cell)        - Filename regexps, e.g. app.FileExtensions
%
%   Outputs:
%       rec_dirs (cell) - Column cell of full folder paths, in dirwalk order.
%                         Empty cell when root_dir is missing or nothing matches
%
%   See also: fillRecordingDirectories, dirwalk, visitor2

rec_dirs = cell(0, 1);

root_dir = char(root_dir);
if isempty(root_dir) || ~isfolder(root_dir)
    return
end

[hits, ~] = dirwalk(root_dir, @visitor2, patterns{:});
hits = hits(~cellfun('isempty', hits));

% Compare without trailing separators: root_dir may have one, and visitor2
% keeps it only for a drive root such as C:\
root_norm = strip_trailing_filesep(root_dir);
hits_norm = cellfun(@strip_trailing_filesep, hits, 'UniformOutput', false);
hits = hits(~strcmp(hits_norm, root_norm));

% Drop hits nested inside another hit
keep = true(size(hits));
for i = 1:numel(hits)
    parent = [hits{i} filesep];
    for j = 1:numel(hits)
        if j ~= i && startsWith(hits{j}, parent)
            keep(j) = false;
        end
    end
end
hits = hits(keep);

rec_dirs = hits(:);

end


function p = strip_trailing_filesep(p)
while numel(p) > 1 && (p(end) == '/' || p(end) == filesep)
    p(end) = [];
end
end
