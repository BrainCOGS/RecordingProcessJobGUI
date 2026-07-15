function [json, success] = loadJSONfile(file)
%LOADJSONFILE Read a JSON file into a struct, reporting failure instead of erroring
%
%   Reads the whole file as text and decodes it with jsondecode, wrapped in a
%   try/catch so that a missing or malformed file yields an empty struct and a
%   false success flag rather than an exception. This is what lets
%   checkConfiguration treat "no system_conf_job_gui.json yet" as "not
%   configured" and send the user to the System Configuration tab, and what
%   lets UploadParamJsonFile reject a bad paramset file the user picked.
%
%   Inputs:
%       file (char) - Path to the JSON file to read. For the app configuration
%                     this is app.ConfFileFullName (system_conf_job_gui.json)
%
%   Outputs:
%       json    (struct) - Decoded JSON as returned by jsondecode. An empty
%                          struct if the read or decode failed
%       success (double) - 1 if the file was read and decoded, 0 otherwise
%
%   See also: saveJSONfile, jsonencodepretty, checkConfiguration,
%   UploadParamJsonFile

success = 1;

try
    fid = fopen(file);
    so = char(fread(fid,inf)');
    json = jsondecode(so);
    fclose(fid);
catch
    success = 0;
    json    = struct;
    fclose(fid);
end

end

