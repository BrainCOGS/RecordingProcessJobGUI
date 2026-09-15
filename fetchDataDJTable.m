function data = fetchDataDJTable(table, key, fields, type, extra_query, no_blobs)
%FETCHDATADJTABLE Fetch a DataJoint relation as a MATLAB table or struct
%
%   Thin wrapper around the DataJoint fetch() used throughout the GUI as the
%   single entry point for reading the database. It restricts the relation by
%   an optional key, selects the requested attributes, optionally appends a raw
%   SQL clause (e.g. an ORDER BY), optionally drops blob attributes so large
%   payloads are not pulled over the wire, and returns either a MATLAB table or
%   the raw struct array that fetch() produces.
%
%   The relation passed in can be any DataJoint relvar, including a join or a
%   proj built by startupFcn (app.RecordingProcessTable, app.RecordingTable, ...)
%   or a bare table class such as recording.Modality or lab.User.
%
%   Inputs:
%       table       (dj.Relvar) - DataJoint relation to read: a table class, or
%                                 a join/restriction/projection of several
%       key         (struct)    - Restriction applied as (table & key). Pass []
%                                 or omit for no restriction. Default: []
%       fields      (cell)      - Cellstr of attribute names to fetch, or {'*'}
%                                 for all. Default: {'*'}
%       type        (string)    - "table" converts the result with struct2table
%                                 ('AsArray', true); any other value (e.g.
%                                 "struct") returns fetch()'s struct array
%                                 unchanged. Default: "table"
%       extra_query (cell/char) - Raw SQL appended after the attribute list, used
%                                 for clauses fetch() has no argument for, e.g.
%                                 "ORDER BY session_date, recording_id". Pass []
%                                 or {} for none. Default: {}
%       no_blobs    (logical)   - true removes every blob attribute
%                                 (table.header.blobNames) from the fetch. When
%                                 fields is {'*'} it is first expanded to the
%                                 full attribute list so the blobs can be
%                                 subtracted. Default: false
%
%   Outputs:
%       data - MATLAB table when type == "table" and the fetch returned rows;
%              otherwise the struct array from fetch(). An empty result is
%              always left as the empty struct fetch() returns, never converted
%              to an empty table
%
%   Dependencies:
%       - DataJoint (fetch, & restriction, relvar.header)
%
%   See also: fetch_table_except, convertTable2Categorical, fillJobTable,
%   fillRecordingTable, startupFcn

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
