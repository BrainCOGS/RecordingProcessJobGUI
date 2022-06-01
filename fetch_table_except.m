function data = fetch_table_except(conn, table_name, fields_remove)


all_fields = conn.query(['DESCRIBE ' table_name]);
all_fields = all_fields.Field;

if ~iscell(fields_remove)
    fields_remove = {fields_remove};
end

for i=1:length(fields_remove)
    all_fields(ismember(all_fields,fields_remove{i})) = [];
end

fields_str = strjoin(all_fields,', ');

data = struct2table(conn.query(['SELECT ' fields_str ' FROM ' table_name]));


