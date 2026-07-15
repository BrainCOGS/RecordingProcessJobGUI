function UploadParamJsonFile(app, event)
%UPLOADPARAMJSONFILE Pick a paramset json file from disk and preview it on the Create Parameters tab
%
%   Shared ButtonPushed callback for the two upload buttons on the Create
%   Parameters tab: app.UploadParamSetFile ("Upload Proc.-Param Set json file")
%   and app.UploadPreParamSetFile ("Upload Preproc.-Param Set json file"). It
%   only *stages* the file - nothing is written to the DB here; the path is
%   remembered and writeParametersDB later hands it to the python
%   upload_params.py script when the matching Register button is pressed.
%
%   event.Source is compared against app.UploadParamSetFile to tell the two
%   buttons apart, which selects both the text-area title prefix and which
%   property the chosen path is stored in. The main figure is hidden around
%   uigetfile so the modal file browser is not drawn behind it.
%
%   The json is read with loadJSONfile and validated only by "did it produce any
%   fields?". On success the pretty-printed contents are shown in
%   app.CreateParamsTextArea, the button turns app.OKColor and the path is kept;
%   on failure the text area is cleared, the button turns app.ErrorColor and the
%   stored path is reset to '' so writeParametersDB will refuse to register.
%   Examples of the expected json live in Original_Params_DB (kilosort_params.json,
%   suite2p_params.json, catgt_params.json, ...).
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - Button ButtonPushed event; event.Source
%                                      distinguishes the processing button
%                                      (app.UploadParamSetFile) from the
%                                      pre-processing one
%
%   Outputs:
%       None - Sets app.NewParamJsonFile or app.NewPreParamJsonFile to the chosen
%              path (or '' if invalid), and updates app.CreateParamsTextArea,
%              app.CreateParamsTextAreaTitle and the source button BackgroundColor
%
%   Dependencies:
%       - loadJSONfile, jsonencodepretty (repo-root helpers)
%       - Original_Params_DB/*.json (example paramset files)
%
%   See also: writeParametersDB, CreatePreparamStepSelected, RegisterPreParamList

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

