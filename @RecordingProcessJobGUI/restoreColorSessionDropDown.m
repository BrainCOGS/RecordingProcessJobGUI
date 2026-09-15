function restoreColorSessionDropDown(app,event)
%RESTORECOLORSESSIONDROPDOWN Clear the guessed-session highlight from the session dropdown
%
%   ValueChanged callback for app.BehaviorSessionDropDown. findLikelyBehaviorSessionFromRecDir
%   tints the dropdown green / yellow / red to report how confident its automatic
%   guess was; once the user picks a session themselves that colour is stale and
%   would be misleading, so this resets the background to app.WhiteColor. The next
%   change of the recording directory dropdown re-runs the guess and re-colours it.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The GUI application object
%       event                        - DropDown ValueChanged event (unused)
%
%   Outputs:
%       None - Resets app.BehaviorSessionDropDown.BackgroundColor to app.WhiteColor
%
%   See also: findLikelyBehaviorSessionFromRecDir, checkBoxSessionRecording

    app.BehaviorSessionDropDown.BackgroundColor = app.WhiteColor;

end














