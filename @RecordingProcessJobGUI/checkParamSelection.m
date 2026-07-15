function checkParamSelection(app, event)
%CHECKPARAMSELECTION Gate recording creation on a complete per-fragment selection
%
%   ButtonPushed callback wired to app.CreateProcessingJobButton2 ("Register
%   Recording") by createRecordingButton when the user opts out of default
%   parameters. It is the last stop before createRecording writes to the database:
%   every fragment must have both a pre-processing step list and a processing
%   paramset, otherwise recording.DefaultParams would be inserted with holes.
%
%   Each of the two "same for all fragments" checkboxes short-circuits its own
%   check, since a broadcast selection covers every fragment by construction. For
%   an unchecked box, the corresponding selection table (app.ParamSelectionTable /
%   app.PreParamSelectionTable) is complete only if it has one row per fragment
%   from 0 up to the highest fragment_number registered - i.e. height must equal
%   max(fragment_number) + 1, fragments being zero-based. A short table means the
%   user skipped one in the middle.
%
%   When neither box is checked the two tables must also agree with each other: the
%   same highest fragment_number on both sides, so no fragment has pre-params but
%   no params or vice versa.
%
%   Any failure raises a uiconfirm error dialog naming the offending side and
%   returns without creating anything. On success it hands off to createRecording.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%       event                        - ButtonPushed event; unused
%
%   Outputs:
%       None - Calls createRecording on success, or shows an error dialog and
%              returns
%
%   Dependencies:
%       - createRecording
%
%   See also: RegisterPreparamFragmentClicked, RegisterParamsFragmentClicked,
%             SamePreParamCheckClicked, createRecordingButton

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

