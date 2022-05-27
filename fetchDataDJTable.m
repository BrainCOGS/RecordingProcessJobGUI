function data = fetchDataDJTable(table, key, fields, type, extra_query)

if nargin < 2
    key = [];
end
if nargin < 3
    fields = {'*'};
end
if nargin < 4
    type = "table";
end

if nargin < 5
    extra_query = {};
end

if ~isempty(extra_query)
    fields = [fields extra_query];
end

if isempty(key)
    data = fetch(table, fields{:});
else
    data = fetch(table & key, fields{:});
end

if ~isempty(data) && type == "table"
    data = struct2table(data,'AsArray', true);
end
