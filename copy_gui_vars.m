function copy_gui_vars(app)
%COPY_GUI_VARS Cache the app's data properties to app_data.mat for offline use
%
%   Saves every property of the app that is not a UI component into the struct
%   app_data in app_data.mat, in the current working directory. A property is
%   kept when its class name does not contain 'matlab.ui', which drops the
%   figure, tabs, tables, dropdowns and other App Designer components (they are
%   not meaningfully saveable) and keeps the data the GUI computed: the
%   Configuration, the fetched params tables, the modality tables and so on.
%
%   This is the save half of the offline cache pair. startupFcn calls it at the
%   end of a successful online startup; when there is no internet it calls
%   load_gui_vars instead, which reads this same file back so the GUI can still
%   display the last known state.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object to cache
%
%   Outputs:
%       None - Writes app_data.mat in the current directory, containing the
%              variable app_data
%
%   See also: load_gui_vars, startupFcn


app_data = struct;
app_fields = fieldnames(app);

for i=1:length(app_fields)
    
    if ~contains(class(app.(app_fields{i})),'matlab.ui')
        app_data.(app_fields{i}) = app.(app_fields{i});
    end
    
end

save('app_data.mat','app_data')