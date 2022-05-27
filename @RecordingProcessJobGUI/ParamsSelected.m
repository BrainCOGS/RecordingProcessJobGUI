
function ParamsSelected(app, event)

if nargin < 2
    event.Source = app.PreprocessingParamsDropDown_2;
end

switch event.Source
            
        case app.PreprocessingParamsDropDown_2
        text_area = app.TextArea_2;
        table_params = app.PreProcessParams;
        desc_field = 'preprocess_paramset_desc';
        param_field = 'preprocess_paramset';
        
        case app.ProcessingParamsDropDown_2
        text_area = app.TextArea_2;
        table_params = app.ProcessParams;
        desc_field = 'process_paramset_desc';
        param_field = 'process_paramset';
    
end

%app.DropdownParamsPrevious.BackgroundColor = app.WhiteColor;
event.Source.BackgroundColor = app.ActiveColor;
app.DropdownParamsPrevious   = event.Source;

%params = table_params{matches(table_params.(desc_field),event.Source.Value), param_field};
%if iscell(params)
%    params = params{:};
%end
%text_area.Value = jsonencodepretty(params);

end
    


