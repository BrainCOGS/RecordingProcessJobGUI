function test_dirwalk()
%TEST_DIRWALK Test and Demo DIRWALK function
%
%

clc

%% Path to top directory (for example)
topPath = fullfile(matlabroot, 'toolbox', 'matlab');


%% Walking with visitor 1 (calculate number of files and size)
%
fprintf('\nWorking DIRWALK with function VISITOR1 (Calculate number of files and size)\n');

% Walking tree and call visitor function in each directory

% "countDirs", "countFiles" and "countBytes" - output arguments of VISITOR1 function
[countDirs, countFiles, countBytes] = dirwalk(topPath, @visitor1);


fprintf('\nTotal directories: %d\nTotal files: %d\nFull Size: %.1f Mb\n', ...
    sum([countDirs{:}]), sum([countFiles{:}]), sum([countBytes{:}])/1048576)
%}


%% Walking with visitor 2 (regexp matching)
fprintf('\nWorking DIRWALK with function VISITOR2 (Select files on patern matching)\n');

% "fileNames" - output argument of VISITOR2 function
% select files types: *.c, *.cpp, *.h
fileNmes = dirwalk(topPath, @visitor2, '^.*\.c$', '^.*\.cpp$', '^.*\.h$');

% All files *.c, *.cpp, *.h
fileNames = vertcat({}, fileNmes{:})
%--------------------------------------------------------------------------


%% ========================================================================

%--------------------------------------------------------------------------



%--------------------------------------------------------------------------


