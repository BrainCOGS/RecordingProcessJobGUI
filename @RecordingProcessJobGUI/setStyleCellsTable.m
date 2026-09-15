function setStyleCellsTable(app, table, style, idx_cells)
%SETSTYLECELLSTABLE Apply a uistyle to a set of cells of a uitable
%
%   Thin wrapper around addStyle that paints an arbitrary list of cells of TABLE
%   in one call. Every table filler in the app routes its status colouring through
%   here, passing app.RED_STYLE for error rows and app.GREEN_STYLE for finished
%   rows (see fillJobTable, fillRecordingTable, fillJobStatusTable,
%   recordingTableSelected).
%
%   IDX_CELLS is an N-by-2 matrix of [row column] subscripts. The callers build it
%   by finding the status column once in the relevant COLUMNS_* constant and
%   repmat-ing that column index against the list of matching rows. addStyle
%   accepts the whole matrix at once, which is why the per-row loop this function
%   used to run is left commented out above.
%
%   Note this does not clear existing styling; callers are expected to call
%   removeStyle on the table first, otherwise styles accumulate.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object (unused; present so
%                                      this can be called as an app method)
%       table (matlab.ui.control.Table) - The uitable to style
%       style (matlab.ui.style.Style) - Style to apply, e.g. app.RED_STYLE or
%                                      app.GREEN_STYLE
%       idx_cells (N-by-2 double)    - [row column] subscripts of the cells to
%                                      paint. Must be non-empty; addStyle errors
%                                      on an empty target
%
%   Outputs:
%       None - Adds the style to the given cells of TABLE
%
%   See also: fillJobTable, fillRecordingTable, fillJobStatusTable, recordingTableSelected

%for i=1:size(idx_cells,1)
%    addStyle(table,style,'cell',idx_cells(i,:))
%end
addStyle(table,style,'cell',idx_cells)

end