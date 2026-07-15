function default_all_params_record = createDefaultParamsRecord(app)
%CREATEDEFAULTPARAMSRECORD Build the recording.DefaultParams rows for a new recording
%
%   Assembles the struct (or struct array) that createRecording inserts into
%   recording.DefaultParams, recording the paramset and pre-process step list each
%   fragment (probe for electrophysiology, FOV for imaging) should be processed
%   with. Only runs when app.CreateRecordingOrJob is true, i.e. when a whole
%   recording is being registered rather than a single job; otherwise it returns an
%   empty struct. recording_id is NOT set here -- createRecording deals it in after
%   the Recording insert.
%
%   The candidate params are first restricted to the configured modality
%   (app.Configuration.RecordingModality) out of app.PreProcessParamList and
%   app.ProcessParams. Field names are modality-dependent and are read from
%   app.preparam_steps_idx_field, app.params_idx_field and
%   app.preprocess_steps_name_field.
%
%   Two paths:
%     - app.DefaultParametersCheckBox checked: one row with fragment_number = 0 and
%       both default_same_preparams_all and default_same_params_all = 1. The ids
%       come from getDefaultParamsMod, which reads the modality's
%       default_preprocess_param_steps_id / default_paramset_idx. If the modality
%       has no pre-processing list (currently the case for imaging),
%       preprocess_param_steps_id falls back to 0.
%     - unchecked: pre-params and params are built independently. If
%       app.SamePreParamListRecordingCheckBox (resp.
%       app.SameParamsRecordingCheckBox) is set, a single fragment_number = 0 row is
%       made from the value of app.PreprocessingParamsDropDown (resp.
%       app.ProcessingParamsDropDown) with default_same_*_all = 1; otherwise the
%       per-fragment table the user built on the Select Parameters tab
%       (app.PreParamSelectionTable / app.ParamSelectionTable) is used with
%       default_same_*_all = 0. If one side is a single row and the other is
%       per-fragment, the single row is replicated to match and given
%       fragment_number 0..N-1. The two tables are then joined on fragment_number,
%       sorted, and converted to a struct array.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%
%   Outputs:
%       default_all_params_record (struct) - One element per fragment, with fields
%                                            fragment_number,
%                                            preprocess_param_steps_id,
%                                            paramset_idx,
%                                            default_same_preparams_all,
%                                            default_same_params_all
%
%   Dependencies:
%       - getDefaultParamsMod
%       - recording.DefaultParams (the table these rows are inserted into)
%
%   See also: createRecording, getDefaultParamsMod, checkParamSelection

default_all_params_record = struct;

this_PreProcessParamList = app.PreProcessParamList(app.PreProcessParamList.recording_modality == app.Configuration.RecordingModality, :);
this_ProcessParams = app.ProcessParams(app.ProcessParams.recording_modality == app.Configuration.RecordingModality, :);

if app.CreateRecordingOrJob
    %Get default parameters if selected
    if app.DefaultParametersCheckBox.Value
        
        default_all_params_record.default_same_preparams_all = 1;
        default_all_params_record.default_same_params_all = 1;
        default_all_params_record.fragment_number = 0;
        
        [default_preparams, default_params] = getDefaultParamsMod(app);
        if isempty(default_preparams)
            default_all_params_record.preprocess_param_steps_id = 0;
        else
            default_all_params_record.preprocess_param_steps_id = default_preparams{1, app.preparam_steps_idx_field };
        end
        default_all_params_record.paramset_idx = default_params{1, app.params_idx_field};
    else
        %If all preparams the same for all probes|fovs
        if app.SamePreParamListRecordingCheckBox.Value
            default_preparams_record.fragment_number = 0;
            default_preparams_record.default_same_preparams_all = 1;
            
            idx_selected_list = find(this_PreProcessParamList.(app.preprocess_steps_name_field) == app.PreprocessingParamsDropDown.Value,1,'first');
            default_preparams_record.preprocess_param_steps_id = this_PreProcessParamList{idx_selected_list, app.preparam_steps_idx_field };
            default_preparams_record = struct2table(default_preparams_record, 'AsArray', true);
        else
            %Table for not all the same preparams already created
            default_preparams_record = app.PreParamSelectionTable;
            default_preparams_record.default_same_preparams_all = zeros(height(default_preparams_record),1);
        end
        %If all params the same  for all probes|fovs
        if app.SameParamsRecordingCheckBox.Value
            default_params_record.fragment_number = 0;
            default_params_record.default_same_params_all = 1;
            
            idx_params = find(this_ProcessParams.paramset_desc == app.ProcessingParamsDropDown.Value,1,'first');
            default_params_record.paramset_idx = this_ProcessParams{idx_params, app.params_idx_field};
            default_params_record = struct2table(default_params_record, 'AsArray', true);
        else
            default_params_record = app.ParamSelectionTable;
            default_params_record.default_same_params_all = zeros(height(default_params_record),1);
        end
        
        %If params equal and preparams different
        if height(default_params_record) == 1 && height(default_preparams_record) > 1 
            default_params_record = repmat(default_params_record, height(default_preparams_record), 1);
            default_params_record.fragment_number = transpose(0:height(default_params_record)-1);
        end
        %If params equal and preparams different
        if height(default_preparams_record) == 1 && height(default_params_record) > 1 
            default_preparams_record = repmat(default_preparams_record, height(default_params_record), 1);
            default_preparams_record.fragment_number = transpose(0:height(default_preparams_record)-1);
        end
        
        default_all_params_record = join(default_preparams_record, default_params_record);
        default_all_params_record = sortrows(default_all_params_record,{'fragment_number'});
        default_all_params_record = table2struct(default_all_params_record);
            
    end
    
end


end

