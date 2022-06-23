function [json, success] = loadJSONfile(file)

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

