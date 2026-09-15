function app = load_gui_vars(app)
%LOAD_GUI_VARS Restore the app's data properties from the app_data.mat cache
%
%   Loads the app_data struct written by copy_gui_vars and copies each cached
%   field back onto the app. Before assigning, the property is looked up in the
%   RecordingProcessJobGUI metaclass property list and only written when its
%   SetAccess is public, so the components and any restricted properties in the
%   classdef are skipped rather than throwing.
%
%   This is the load half of the offline cache pair: startupFcn calls
%   copy_gui_vars after a successful online startup, and calls this instead
%   when there is no internet, so the GUI comes up showing the last state
%   fetched from the database rather than empty.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object to populate
%
%   Outputs:
%       app (RecordingProcessJobGUI) - The same object with its public cached
%                                      properties restored. app is a handle, so
%                                      the caller's copy is updated either way
%
%   Dependencies:
%       - app_data.mat in the current directory, written by copy_gui_vars
%
%   See also: copy_gui_vars, startupFcn

data = load('app_data.mat');
app_fields = fieldnames(data.app_data);


mc = ?RecordingProcessJobGUI;
props = mc.PropertyList;
propNames = {props.Name};

for i=1:length(app_fields)
    
    idx_prop = find(matches(propNames,app_fields{i}));
    if ~isempty(idx_prop)
        access = props(idx_prop).SetAccess;

        if access == "public"
            app.(app_fields{i}) = data.app_data.(app_fields{i});
        end
    end

end


end
