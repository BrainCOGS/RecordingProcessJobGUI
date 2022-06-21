function checkParamSelection(app, event)

if ~app.SameParamsRecordingCheckBox.Value
    param_fragments = app.ParamSelectionTable.fragment_number;
    max_param_fragment = max(param_fragments);
    if length(param_fragments) < (max_param_fragment+1)
        uiconfirm(app.UIFigure, 'Missing fragments in processing parameter selection', 'Parameter selection', 'Icon','error');
        return;
    end
end
if ~app.SamePreParamListRecordingCheckBox.Value
    preparam_fragments = app.PreParamSelectionTable.fragment_number;
    max_preparam_fragment = max(preparam_fragments);
    if length(preparam_fragments) < (max_preparam_fragment+1)
        uiconfirm(app.UIFigure, 'Missing fragments in preprocess parameter selection', 'Parameter selection', 'Icon','error');
        return;
    end
    
end
if ~app.SamePreParamListRecordingCheckBox.Value && ~app.SameParamsRecordingCheckBox.Value
    if max_param_fragment < max_preparam_fragment
        uiconfirm(app.UIFigure, 'Missing fragments in processing parameter selection', 'Parameter selection', 'Icon','error');
        return
    end
    if max_preparam_fragment < max_param_fragment
        uiconfirm(app.UIFigure, 'Missing fragments in preprocess parameter selection', 'Parameter selection', 'Icon','error');
        return
    end
end

createRecording(app);
    
    
    
end

