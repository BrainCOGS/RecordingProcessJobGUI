%% ========================================================================
function [dirs, fileNames] = visitor2(rootPath, Listing, varargin)
%VISITOR2 Visitor function
%
% Description:
%   Select files on regexp paterns matching.
%
% Input:
%   rootPath -- Path to visited directory. String
%   Listing  -- Visited directory listing. Array of structs (output of function DIR)
%   varargin -- Regexp paterns
%

% Check number of output arguments
nargoutchk(0, 2)

names = {Listing.name}';
isDirs = [Listing.isdir];
fileNames = names(~isDirs);

pInds = zeros(numel(fileNames), 1);

paterns = varargin;

for i = 1:numel(paterns)
    matchNames = regexp(fileNames, paterns{i}, 'once', 'match');
    cInds = ~cellfun('isempty', matchNames);
    pInds = pInds | cInds;
end

fileNames = cellfun(@(x) fullfile(rootPath, x), fileNames(pInds), 'UniformOutput', 0);
dirs      = unique(cellfun(@fileparts, fileNames, 'UniformOutput', 0));
dirs = vertcat(dirs{:});

