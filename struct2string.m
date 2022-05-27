function out_string = struct2string(in_struct, with_fields)

if nargin < 2
    with_fields = false;
end

out_string = string;
fields = fieldnames(in_struct);

for i=1:length(fields)
    
    if with_fields
        out_string = out_string + string(fields{i}) + ": ";
    end
    out_string = out_string + string(in_struct.fields{i}) + "  ";
end
    
    
