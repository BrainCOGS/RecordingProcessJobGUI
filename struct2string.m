function out_string = struct2string(in_struct, with_fields)
%STRUCT2STRING Flatten a struct's values into one space-separated string
%
%   Walks the fields of a scalar struct in fieldnames() order and appends each
%   value to a string, separated by two spaces, optionally prefixing each value
%   with "<fieldname>: ". Intended for collapsing a small key/value struct (a
%   filter key, a paramset) into one line for a label or a dropdown entry.
%
%   NOTE: this function has no callers in the repo, so it is effectively dead
%   code. Exercise it before relying on it.
%
%   Inputs:
%       in_struct   (struct)  - Scalar struct whose values are to be flattened.
%                               Every value must be convertible by string()
%       with_fields (logical) - true prefixes each value with its field name
%                               and ": ". Default: false
%
%   Outputs:
%       out_string (string) - The values joined by two spaces, with field name
%                             prefixes when with_fields is true
%
%   See also: catstruct, jsonencodepretty

if nargin < 2
    with_fields = false;
end

out_string = string;
fields = fieldnames(in_struct);

for i=1:length(fields)
    
    if with_fields
        out_string = out_string + string(fields{i}) + ": ";
    end
    out_string = out_string + string(in_struct.(fields{i})) + "  ";
end
    
    
