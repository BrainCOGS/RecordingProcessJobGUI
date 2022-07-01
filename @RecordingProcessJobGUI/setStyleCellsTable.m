function setStyleCellsTable(app, table, style, idx_cells)

%for i=1:size(idx_cells,1)
%    addStyle(table,style,'cell',idx_cells(i,:))
%end
addStyle(table,style,'cell',idx_cells)

end