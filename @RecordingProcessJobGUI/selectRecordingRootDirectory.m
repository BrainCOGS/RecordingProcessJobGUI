function selectRecordingRootDirectory(app, event)


app.UIFigure.Visible = 'off';

sel_dir = uigetdir(app.RecordingRootDirectoryEdit.Value);

app.UIFigure.Visible = 'on';

if ischar(sel_dir)
    app.RecordingRootDirectoryEdit.Value = sel_dir;
end


end

