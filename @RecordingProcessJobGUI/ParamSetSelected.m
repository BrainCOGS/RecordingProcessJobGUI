
function ParamSetSelected(app, event)
%PARAMSETSELECTED Show the details of the processing paramset picked in the dropdown
%
%   ValueChanged callback for app.ProcessingParamsDropDown. Looks the selected
%   paramset_desc up in app.ProcessParams and displays its metadata: the author
%   and creation date ('user_params' / 'date_params', split out of the raw
%   description by splitDescriptionColumnParams) go into app.UserDateParamsLabel2,
%   and the paramset contents themselves are pretty-printed as JSON into the
%   shared app.ParamsTextArea.
%
%   The JSON pane is only filled when app.py_enabled, because the 'params' column
%   is only populated by the python read_params.py round-trip; without python the
%   text area is left showing whatever was there before.
%
%   Note the text area is shared with PreparamStepSelected: whichever of the two
%   fired last owns it, and app.ParamsTextAreaTitle says which ("Processing
%   paramset: ..." here).
%
%   Also called directly (not as a callback) by fillParams2Select and
%   ParamListSelected, passing the dropdown handle itself in place of the event -
%   a uidropdown has a .Value property, so event.Value works either way.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ValueChanged event, or the
%                                      app.ProcessingParamsDropDown handle. Only
%                                      event.Value (the paramset_desc) is used
%
%   Outputs:
%       None - Updates app.UserDateParamsLabel2 and, if app.py_enabled,
%              app.ParamsTextArea and app.ParamsTextAreaTitle
%
%   Dependencies:
%       - jsonencodepretty
%       - app.ProcessParams (filled by fillParams)
%
%   See also: ParamListSelected, PreparamStepSelected, fillParams2Select

if isempty(event.Value)
    return;
end

params_selected = event.Value;
idx_params = app.ProcessParams.paramset_desc == params_selected;

%Date and description
user_date = app.ProcessParams{idx_params, {'user_params', 'date_params'}};
user_date = strjoin(string(user_date));

app.UserDateParamsLabel2.Text = user_date;

if app.py_enabled
    selected_params = app.ProcessParams{idx_params, 'params'};
    selected_params = selected_params{1};
       
    app.ParamsTextArea.Value = jsonencodepretty(selected_params);
    app.ParamsTextAreaTitle.Text = ['Processing paramset:    ' params_selected];
end



end
    




