function UploadParamJsonFile(app, event)

app.UIFigure.Visible = 'off';
[file,path] = uigetfile('*.json');
app.UIFigure.Visible = 'on';

if event.Source == app.UploadParamSetFile
    title_label_text = 'Processing file: ';
else
    title_label_text = 'Preprocess-param file: ';
end

complete_filename = fullfile(path, file);
json_data = loadJSONfile(complete_filename);

if isempty(fieldnames(json_data))
    uiconfirm(app.UIFigure,'No valid json file.',  'New Parameters',  'Icon','error');
    app.CreateParamsTextArea.Value = '';
    app.CreateParamsTextAreaTitle.Text = [title_label_text 'No valid json file'];
    event.Source.BackgroundColor = app.ErrorColor;
    
    %Check which button was clicked to upload
    if event.Source == app.UploadParamSetFile
        app.NewParamJsonFile = '';
    else
        app.NewPreParamJsonFile = '';
    end
    
    return
else
    
    app.CreateParamsTextArea.Value = jsonencodepretty(json_data);
    app.CreateParamsTextAreaTitle.Text = [title_label_text file];
    event.Source.BackgroundColor = app.OKColor;
    
    %Check which button was clicked to upload
    if event.Source == app.UploadParamSetFile
        app.NewParamJsonFile = complete_filename;
    else
        app.NewPreParamJsonFile = complete_filename;
    end
end




end

