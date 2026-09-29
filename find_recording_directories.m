function rec_dirs = find_recording_directories(root_dir, patterns, collapse_nested)
%FIND_RECORDING_DIRECTORIES List the folders under a root that hold raw recording files
%
%   Builds the candidate list behind the Add Recording tab's Recording Directory
%   dropdown. Walks every folder under root_dir (any depth) with dirwalk/visitor2
%   and keeps each folder that directly contains a file whose name matches one of
%   the regexps in patterns. root_dir itself is never returned, even if it holds
%   matching files.
%
%   collapse_nested drops every hit that sits inside another hit. That is for
%   electrophysiology: a SpikeGLX gate folder (run_g0/, holding the nidq file)
%   is the recording, and its per-probe subfolders (run_g0_imec0/, ...) must not
%   be listed as recordings of their own. Imaging has no such layout, so it
%   passes false and every folder with raw files is listed. Nesting is decided
%   on whole path components, so .../rec1 never hides a sibling .../rec10.
%
%   Inputs:
%       root_dir        (char/string) - Recording root directory to walk
%       patterns        (cell)        - Filename regexps, e.g. app.FileExtensions
%       collapse_nested (logical)     - Drop hits nested inside another hit
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

if collapse_nested
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
end

rec_dirs = hits(:);

end


function p = strip_trailing_filesep(p)
while numel(p) > 1 && (p(end) == '/' || p(end) == filesep)
    p(end) = [];
end
end
