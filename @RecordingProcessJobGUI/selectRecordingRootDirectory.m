function selectRecordingRootDirectory(app, event)


app.UIFigure.Visible = 'off';

sel_dir = uigetdir('/Users/alvaros/Documents/MATLAB/BrainCogsProjects/Datajoint_proj');

app.UIFigure.Visible = 'on';

if ischar(sel_dir)
    app.RecordingRootDirectoryEdit.Value = sel_dir;
end


end

