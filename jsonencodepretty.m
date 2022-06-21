function json_pretty = jsonencodepretty(text)

if iscell(text)
    text = text{1};
end

json_pretty = jsonencode(text);

all_fields =  fieldnames(text);

for i=2:length(all_fields)
       idx_field = strfind(json_pretty, all_fields{i}+""":");
       json_pretty = [json_pretty(1:idx_field-1), sprintf('\r'), json_pretty(idx_field:end)];
end

json_pretty = strrep(json_pretty, '[{', sprintf('[\r{\r'));
json_pretty = strrep(json_pretty, '}]', sprintf('\r}\r]'));