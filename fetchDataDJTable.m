function data = fetchDataDJTable(table, key, fields, type, extra_query, no_blobs)

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

if nargin < 6
   no_blobs = false; 
end

%Remove blob fields from fetch
if no_blobs
    blob_fields = table.header.blobNames;
    if fields{1} == '*'
        fields = {table.header.attributes.name};
    end
    for i=1:length(blob_fields)
        idx = find(ismember(fields, blob_fields{i}));
        if ~isempty(idx)
            fields(idx) = [];
        end
    end
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
