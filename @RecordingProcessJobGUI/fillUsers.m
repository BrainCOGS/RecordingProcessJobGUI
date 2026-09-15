
function fillUsers(app, key)
%FILLUSERS Fill the paramset-author dropdown on the Create Parameters tab
%
%   Populates app.UserPreparamListDrop (Create Parameters tab, GridLayoutCP) with the
%   literal entry 'general-user' followed by every user_id fetched from lab.User under
%   the restriction key. This dropdown is not a table filter: its Value is the author
%   stamped into the description of any paramset or pre-process step list written to the
%   database, which RegisterPreParamList and writeParametersDB compose as
%   '<user>_<yyyy-mm-dd>_<description>' (the same three-part convention that
%   splitDescriptionColumnParams later splits back apart). 'general-user' is the
%   not-attributed-to-anyone bucket.
%
%   FillEverything calls it with the char restriction
%   'active_gui_user=1 and primary_tech="N/A"', i.e. only users flagged as active GUI
%   users who are not technicians.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The main application object
%       key (char | struct | [])     - Optional DataJoint restriction on lab.User. Used
%                                      as a raw SQL condition string by FillEverything.
%                                      Defaults to [] (every lab.User).
%
%   Outputs:
%       None - Sets app.UserPreparamListDrop.Items
%
%   Dependencies:
%       - fetchDataDJTable
%       - DataJoint: lab.User
%
%   See also: fillSubjects, RegisterPreParamList, writeParametersDB, FillEverything

if nargin < 2
    key = [];
end

users_subj = fetchDataDJTable(lab.User, key, {'user_id'}, "struct");

app.UserPreparamListDrop.Items = {'general-user', users_subj.user_id};
end