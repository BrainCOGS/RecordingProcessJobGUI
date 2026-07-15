function data = fetch_table_except(conn, table_class, fields_remove)
%FETCH_TABLE_EXCEPT Fetch every column of a DataJoint table except some
%
%   Reads a whole DataJoint table over a raw SQL connection while excluding
%   named columns. It exists because fetch() cannot say "everything but X":
%   the paramset tables carry a large `params` blob that the GUI never needs
%   when it only wants the paramset list, so getParamsFromMatlab calls this to
%   pull the ProcessingParamSet / PreClusterParamSet rows without it.
%
%   The column list is discovered with a SQL DESCRIBE on the table, the
%   unwanted names are dropped, and the remainder is SELECTed by name. The
%   whole table is returned - there is no restriction argument.
%
%   Inputs:
%       conn          (dj.Connection) - Open DataJoint connection, normally
%                                       dj.conn. Used for its query() method
%       table_class   (dj.Relvar)     - Table object whose fullTableName gives
%                                       the `database`.`table` to read
%       fields_remove (char/cell)     - Column name, or cellstr of column names,
%                                       to leave out of the SELECT. A char is
%                                       wrapped into a cell automatically
%
%   Outputs:
%       data (table) - MATLAB table with one row per database row and one
%                      variable per remaining column
%
%   Dependencies:
%       - DataJoint (dj.conn, relvar.fullTableName, conn.query)
%
%   See also: fetchDataDJTable, getParamsFromMatlab, convertTable2Categorical

table_name= table_class.fullTableName;

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


