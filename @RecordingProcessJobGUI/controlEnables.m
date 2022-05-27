
function controlEnables(app, structEnables)

%Which objects are going to be enabled and which disabled


if isfield(structEnables, 'Enable')
    for i =1:length(structEnables.Enable)
        
        app.(structEnables.Enable{i}).Enable = 'on';
    end
end

if isfield(structEnables, 'Disable')
    for i =1:length(structEnables.Disable)
        
        app.(structEnables.Disable{i}).Enable = 'off';
    end
end


end