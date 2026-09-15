
function controlEnables(app, structEnables)
%CONTROLENABLES Enable and disable a batch of GUI components by property name
%
%   Small helper that saves callbacks from writing one `.Enable = ...` line per
%   component. Each entry is the *name* of a RecordingProcessJobGUI property holding
%   a UI component, and is resolved dynamically as app.(name).Enable.
%
%   structEnables has up to two fields, both optional (a missing field simply means
%   "leave those alone"):
%       .Enable  - cell array of char component property names to set 'on'
%       .Disable - cell array of char component property names to set 'off'
%   e.g. structEnables.Enable  = {'BehaviorSessionDropDown'};
%        structEnables.Disable = {'RecordingSubjectDropDown', 'RecordingDateDatePicker'};
%   Callers that flip a form between two states (checkBoxSessionRecording) just swap
%   the two fields. A name that is not a property of app errors.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       structEnables (struct)       - Struct with optional .Enable / .Disable cell
%                                      arrays of component property names
%
%   Outputs:
%       None - Sets the Enable property of the named components
%
%   See also: checkBoxSessionRecording, configureSystem, startConfiguration

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