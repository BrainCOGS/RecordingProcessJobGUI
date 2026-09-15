

function CreatePreparamStepSelected(app, event)
%CREATEPREPARAMSTEPSELECTED Preview the params of the pre-processing step picked in the dropdown
%
%   ValueChanged callback for app.PreParamsStepsDrop on the Create Parameters tab.
%   The dropdown Items are built by fillPreParamsSets as "<preprocess_method> :
%   <paramset_desc>" strings; this splits the selected one on the colon, looks the
%   pair up in app.PreProcessParams (the cached pre-processing paramset table for
%   all modalities) and shows that row's 'params' blob pretty-printed in
%   app.CreateParamsTextArea, so the user can see what a step actually contains
%   before adding it to a new step list with AddPreParamStepNewList.
%
%   Read-only: it does not touch the DB or the step list being assembled. If the
%   method/description pair matches more than one row only the first is shown.
%   The whole body is gated on app.py_enabled.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - Dropdown ValueChanged event (unused; the
%                                      selection is read from
%                                      app.PreParamsStepsDrop.Value)
%
%   Outputs:
%       None - Updates app.CreateParamsTextArea and app.CreateParamsTextAreaTitle
%
%   Dependencies:
%       - jsonencodepretty (repo-root helper)
%       - app.PreProcessParams (filled by fillParams)
%
%   See also: fillPreParamsSets, AddPreParamStepNewList, RegisterPreParamList

if app.py_enabled
    selected_preparam = app.PreParamsStepsDrop.Value;
    idx_twop = strfind(selected_preparam,":");
    preparam_method = strtrim(selected_preparam(1:idx_twop-1));
    steplist_desc = strtrim(selected_preparam(idx_twop+1:end));
    
    selected_params = app.PreProcessParams{...
        app.PreProcessParams.preprocess_method == categorical({preparam_method}) & ...
        app.PreProcessParams.paramset_desc == categorical({steplist_desc}), 'params'};
    selected_params = selected_params(1);
       
    app.CreateParamsTextArea.Value = jsonencodepretty(selected_params);
    
    app.CreateParamsTextAreaTitle.Text = ['Preprocess paramset:    ' selected_preparam];
    
end

end
    

