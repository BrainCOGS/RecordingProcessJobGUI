function  FillEverything(app)
%FILLEVERYTHING Refresh every database-backed table and filter dropdown in the GUI
%
%   The refresh-all entry point. Called once from startupFcn after a valid
%   configuration is found, and again from configureSystem after the system is
%   reconfigured, so that a modality or behavior-rig change is reflected everywhere
%   at once. Everything it calls re-queries DataJoint, so this is the expensive path.
%
%   What it refreshes, all unrestricted (no filter key), so each call resets the
%   tabs to their unfiltered contents:
%     - fillJobTable           - app.JobTable, the Manage Processing Jobs listing,
%                                plus the app.DataTable cache behind it
%     - fillRecordingTable     - app.RecordingTableRT, the Recording Table listing,
%                                plus the app.DataRecordingTable cache behind it
%     - fillRecordingSubject   - app.SubjectDropDown_2, subject filter (jobs tab)
%     - fillRecordingSubjectRT - app.SubjectDropDownRT, subject filter (Recording
%                                Table tab)
%     - fillRecordingUser      - app.UserDropDown, user filter (jobs tab)
%     - fillRecordingUserRT    - app.UserDropDownRT, user filter (Recording Table tab)
%     - fillUsers              - app.UserPreparamListDrop, the user picker on the
%                                Create Parameters tab, restricted here to active
%                                GUI users who are not techs
%                                (active_gui_user=1 and primary_tech="N/A") and
%                                prefixed with 'general-user'
%
%   The *RT variants exist because the Manage Processing Jobs tab and the Recording
%   Table tab keep independent filters over different base tables
%   (app.RecordingProcessTable / ...2, the job queries, vs app.RecordingTable /
%   ...2, the recording queries), so each needs its own dropdown contents.
%
%   Note this does not refresh the configuration-dependent recording directory
%   listing or the params dropdowns - those are postConfigurationActions' job.
%
%   Inputs:
%       app (RecordingProcessJobGUI) - The application object
%
%   Outputs:
%       None - Repopulates app.JobTable, app.RecordingTableRT, the subject / user
%              filter dropdowns on the Manage Processing Jobs and Recording Table
%              tabs, and app.UserPreparamListDrop
%
%   Dependencies:
%       - fillJobTable, fillRecordingTable, fillRecordingSubject,
%         fillRecordingSubjectRT, fillRecordingUser, fillRecordingUserRT, fillUsers
%
%   See also: startupFcn, configureSystem, postConfigurationActions

fillJobTable(app);
fillRecordingTable(app);

fillRecordingSubject(app);
fillRecordingSubjectRT(app);

fillRecordingUser(app);
fillRecordingUserRT(app);

fillUsers(app, 'active_gui_user=1 and primary_tech="N/A"');



end

