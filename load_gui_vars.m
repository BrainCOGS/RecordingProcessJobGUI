function app = load_gui_vars(app)

data = load('app_data.mat');
app_fields = fieldnames(data.app_data);


mc = ?RecordingProcessJobGUI;
props = mc.PropertyList;
propNames = {props.Name};

for i=1:length(app_fields)
    
    idx_prop = find(matches(propNames,app_fields{i}));
    if ~isempty(idx_prop)
        access = props(idx_prop).SetAccess;
    end
    
    if access == "public"
        app.(app_fields{i}) = data.app_data.(app_fields{i});        
    end
    
end

su = 1


end
