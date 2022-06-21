function copy_gui_vars(app)


app_data = struct;
app_fields = fieldnames(app);

for i=1:length(app_fields)
    
    if ~contains(class(app.(app_fields{i})),'matlab.ui')
        app_data.(app_fields{i}) = app.(app_fields{i});
    end
    
end

save('app_data.mat','app_data')