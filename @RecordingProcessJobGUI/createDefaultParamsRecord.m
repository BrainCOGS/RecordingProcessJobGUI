function default_all_params_record = createDefaultParamsRecord(app)
%CREATEDEFAULTPARAMSRECORD

default_all_params_record = struct;

if app.CreateRecordingOrJob
    %Get default parameters if selected
    if app.DefaultParametersCheckBox.Value
        
        default_all_params_record.default_same_preparams_all = 1;
        default_all_params_record.default_same_params_all = 1;
        default_all_params_record.fragment_number = 0;
        
        [default_preparams, default_params] = getDefaultParamsMod(app);
        default_all_params_record.preprocess_param_steps_id = default_preparams{1, app.preparam_steps_idx_field };
        default_all_params_record.paramset_idx = default_params{1, app.params_idx_field};
    else
        %If all preparams the same for all probes|fovs
        if app.SamePreParamListRecordingCheckBox.Value
            default_preparams_record.fragment_number = 0;
            default_preparams_record.default_same_preparams_all = 1;
            
            idx_selected_list = find(app.PreProcessParamList.(app.preparam_steps_name_field) == app.PreprocessingParamsDropDown.Value,1,'first');
            default_preparams_record.preprocess_param_steps_id = app.PreProcessParamList{idx_selected_list, app.preparam_steps_idx_field };
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
            
            idx_params = find(app.ProcessParams.paramset_desc == app.ProcessingParamsDropDown.Value,1,'first');
            default_params_record.paramset_idx = app.ProcessParams{idx_params, app.params_idx_field};
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

