
function PreparamStepSelected(app, event)
%PREPARAMSTEPSELECTED Show the params of the pre-processing step picked in the list
%
%   ValueChanged callback for app.PreprocessingParamsStepsList. Each item in that
%   list was built by ParamListSelected as "<method>: <paramset_desc>", so this
%   splits on the first ":" to recover the step's paramset_desc, finds the row of
%   app.PreProcessParamList matching that paramset_desc *within* the step list
%   currently selected in app.PreprocessingParamsDropDown, and pretty-prints its
%   'params' column as JSON into app.ParamsTextArea.
%
%   Both restrictions are needed: the same paramset_desc can appear in more than
%   one step list, and the step-list name disambiguates it.
%
%   Does nothing unless app.py_enabled, since the 'params' column is only
%   populated by the python read_params.py round-trip. The text area is shared
%   with ParamSetSelected; app.ParamsTextAreaTitle is set to "Preprocessing
%   paramset: ..." to say which one is on show.
%
%   Also called directly by ParamListSelected right after it repopulates the steps
%   list, so the pane never lags behind the dropdown.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ValueChanged event; unused, the value is
%                                      read from app.PreprocessingParamsStepsList
%
%   Outputs:
%       None - Updates app.ParamsTextArea and app.ParamsTextAreaTitle
%
%   Dependencies:
%       - jsonencodepretty
%       - app.PreProcessParamList (filled by fillParams)
%
%   See also: ParamListSelected, ParamSetSelected, fillParams2Select

if app.py_enabled
    selected_list = app.PreprocessingParamsStepsList.Value;
    idx_twop = strfind(selected_list,":");
    steplist_desc = strtrim(selected_list(idx_twop+1:end));
    
    selected_params = app.PreProcessParamList{...
        app.PreProcessParamList.paramset_desc == categorical({steplist_desc}) & ...
        app.PreProcessParamList.(app.preprocess_steps_name_field) == app.PreprocessingParamsDropDown.Value, 'params'};
    selected_params = selected_params(1);
       
    app.ParamsTextArea.Value = jsonencodepretty(selected_params);
    
    app.ParamsTextAreaTitle.Text = ['Preprocessing paramset:    ' selected_list];
    
end

end
    


