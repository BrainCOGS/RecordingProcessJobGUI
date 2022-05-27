function varargout = visitor1(rootPath, Listing, varargin)
%VISITOR1 Visitor function
%
% Signatures:
%   [out1m out2, ..., outN] = visitor(rootPath, Listing)
%   varargout = visitor(rootPath, Listing)
%   [...] = visitor(rootPath, Listing, inp1, inp2, ..., inpN)
%   [...] = visitor(rootPath, Listing, varargin)
%
% Input:
%   rootPath -- Path to visited directory. String
%   Listing  -- Visited directory listing. Array of structs (output of function DIR)
%
% Output:
%   Any number of output arguments
%

% Test example:

% Check number of output arguments
nargoutchk(0, 3)

% Get files info
names = {Listing.name}';
bytes = sum([Listing.bytes]);

isDirs = [Listing.isdir];

dirNames = names(isDirs);
fileNames = names(~isDirs);

inds = ~strcmp(dirNames, '.') & ~strcmp(dirNames, '..');
dirNames = dirNames(inds);

countDirs = numel(dirNames);
countFiles = numel(fileNames);

% Display Info
fprintf('    %4d files in directory: "%s"\n', countFiles, rootPath)

% Return output arguments
varargout{1} = countDirs;
varargout{2} = countFiles;
varargout{3} = bytes;