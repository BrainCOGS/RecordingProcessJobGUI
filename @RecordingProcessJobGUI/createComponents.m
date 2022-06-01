function createComponents(app)

% Create UIFigure and hide until all components are created
app.UIFigure = uifigure('Visible', 'off');
screenSize = get(groot,'ScreenSize');
app.UIFigure.Position = [100 100 screenSize(3)*0.8 screenSize(4)*0.8];
app.UIFigure.Name = 'MATLAB App';

% Create GridLayout4
app.GridLayout4 = uigridlayout(app.UIFigure);
app.GridLayout4.ColumnWidth = {'1x', '4x', '4x', '1.5x', '1x'};
app.GridLayout4.RowHeight = {'4x', '2x', '5x', '100x'};
app.GridLayout4.ColumnSpacing = 1.5;
app.GridLayout4.RowSpacing = 2.25;
app.GridLayout4.Padding = [1.5 2.25 1.5 2.25];

% Create U19RecordingProcessingJobsGUILabel
app.U19RecordingProcessingJobsGUILabel = uilabel(app.GridLayout4);
app.U19RecordingProcessingJobsGUILabel.FontSize = 26;
app.U19RecordingProcessingJobsGUILabel.FontWeight = 'bold';
app.U19RecordingProcessingJobsGUILabel.Layout.Row = [1 3];
app.U19RecordingProcessingJobsGUILabel.Layout.Column = [2 4];
app.U19RecordingProcessingJobsGUILabel.Text = '   U19 Recording Processing Jobs GUI';

% Create Image
app.Image = uiimage(app.GridLayout4);
app.Image.Layout.Row = [1 3];
app.Image.Layout.Column = 1;
app.Image.ImageSource = 'brain_cogs_on_white_small_brain_cogs_on_white.png';

% Create Label info Configuration
app.ConfigurationLabel = uihtml(app.GridLayout4);
app.ConfigurationLabel.Layout.Row = 3;
app.ConfigurationLabel.Layout.Column = [1 5];
app.ConfigurationLabel.HTMLSource = app.InfoStyle;

% Create TabGroup
app.TabGroup = uitabgroup(app.GridLayout4);
app.TabGroup.Layout.Row = 4;
app.TabGroup.Layout.Column = [1 5];

%%%%%%%%%%%%%%%%%%%%%%%%  TAB1       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create AddRecordingProcessingJobTab
app.AddRecordingProcessingJobTab = uitab(app.TabGroup);
app.AddRecordingProcessingJobTab.Title = 'Add Recording';


% Create GridLayout2
app.GridLayout2 = uigridlayout(app.AddRecordingProcessingJobTab);
app.GridLayout2.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};
app.GridLayout2.RowHeight = {'1x', '1x', 2, '1x', '1x', '1x', 2, '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

% Create SelectRecordingDirectoryLabel
app.SelectRecordingDirectoryLabel = uilabel(app.GridLayout2);
app.SelectRecordingDirectoryLabel.FontSize = 16;
app.SelectRecordingDirectoryLabel.FontWeight = 'bold';
app.SelectRecordingDirectoryLabel.Layout.Row = 1;
app.SelectRecordingDirectoryLabel.Layout.Column = [1 3];
app.SelectRecordingDirectoryLabel.Text = '1. Select Recording Directory';

% Create RecordingDirectoryDropDownLabel
app.RecordingDirectoryDropDownLabel = uilabel(app.GridLayout2);
app.RecordingDirectoryDropDownLabel.HorizontalAlignment = 'right';
app.RecordingDirectoryDropDownLabel.Layout.Row = 2;
app.RecordingDirectoryDropDownLabel.Layout.Column = 1;
app.RecordingDirectoryDropDownLabel.Text = 'Recording Directory';

% Create RecordingDirectoryDropDown
app.RecordingDirectoryDropDown = uidropdown(app.GridLayout2);
app.RecordingDirectoryDropDown.Layout.Row = 2;
app.RecordingDirectoryDropDown.Layout.Column = [2 4];
app.RecordingDirectoryDropDown.Items = {};

% Create IstherebehaviorSessionCheckBox
app.IstherebehaviorSessionCheckBox = uicheckbox(app.GridLayout2);
app.IstherebehaviorSessionCheckBox.Text = 'Is there behavior Session for Recording?';
app.IstherebehaviorSessionCheckBox.Layout.Row = 5;
app.IstherebehaviorSessionCheckBox.Layout.Column = [1 4];
app.IstherebehaviorSessionCheckBox.Value = true;
app.IstherebehaviorSessionCheckBox.ValueChangedFcn = createCallbackFcn(app, @checkBoxSessionRecording, true);
app.IstherebehaviorSessionCheckBox.Enable = 'off';


% Create BehaviorSessionDropDownLabel
app.BehaviorSessionDropDownLabel = uilabel(app.GridLayout2);
app.BehaviorSessionDropDownLabel.HorizontalAlignment = 'right';
app.BehaviorSessionDropDownLabel.Layout.Row = 6;
app.BehaviorSessionDropDownLabel.Layout.Column = 1;
app.BehaviorSessionDropDownLabel.Text = 'Behavior Session';

% Create BehaviorSessionDropDown
app.BehaviorSessionDropDown = uidropdown(app.GridLayout2);
app.BehaviorSessionDropDown.Layout.Row = 6;
app.BehaviorSessionDropDown.Layout.Column = [2 4];
app.BehaviorSessionDropDown.Items = {};

% Create RecordingSubjectDropDownLabel
app.RecordingSubjectDropDownLabel = uilabel(app.GridLayout2);
app.RecordingSubjectDropDownLabel.HorizontalAlignment = 'right';
app.RecordingSubjectDropDownLabel.Layout.Row = 5;
app.RecordingSubjectDropDownLabel.Layout.Column = 5;
app.RecordingSubjectDropDownLabel.Text = 'Recording Subject';
app.RecordingSubjectDropDownLabel.Enable = 'off';

% Create RecordingSubjectDropDown_2
app.RecordingSubjectDropDown = uidropdown(app.GridLayout2);
app.RecordingSubjectDropDown.Layout.Row = 5;
app.RecordingSubjectDropDown.Layout.Column = [6 7];
app.RecordingSubjectDropDown.Enable = 'off';
app.RecordingSubjectDropDown.Items = {};

% Create Label
app.Label = uilabel(app.GridLayout2);
app.Label.BackgroundColor = [0 0 0];
app.Label.Layout.Row = 3;
app.Label.Layout.Column = [1 7];

% Create SelectSessionorLabel
app.SelectSessionorLabel = uilabel(app.GridLayout2);
app.SelectSessionorLabel.FontSize = 16;
app.SelectSessionorLabel.FontWeight = 'bold';
app.SelectSessionorLabel.Layout.Row = 4;
app.SelectSessionorLabel.Layout.Column = [1 4];
app.SelectSessionorLabel.Text = '2. Select Session (or Subject and Date) for Recording';

% Create Label2
app.Label2 = uilabel(app.GridLayout2);
app.Label2.BackgroundColor = [0 0 0];
app.Label2.Layout.Row = 7;
app.Label2.Layout.Column = [1 7];
app.Label2.Text = 'Label2';

% Create SelectProcessingParametersLabel
app.SelectProcessingParametersLabel = uilabel(app.GridLayout2);
app.SelectProcessingParametersLabel.FontSize = 16;
app.SelectProcessingParametersLabel.FontWeight = 'bold';
app.SelectProcessingParametersLabel.Layout.Row = 8;
app.SelectProcessingParametersLabel.Layout.Column = [1 7];
app.SelectProcessingParametersLabel.Text = '3. Select Processing Parameters';


% Create DefaultParametersCheckBox
app.DefaultParametersCheckBox = uicheckbox(app.GridLayout2);
app.DefaultParametersCheckBox.Text = 'Use default processing parameters for recording ? ';
app.DefaultParametersCheckBox.Layout.Row = 9;
app.DefaultParametersCheckBox.Layout.Column = [1 4];
app.DefaultParametersCheckBox.Value = true;
app.DefaultParametersCheckBox.Enable = 'on';


% Create CreateProcessingJobButton
app.CreateProcessingJobButton = uibutton(app.GridLayout2, 'push');
app.CreateProcessingJobButton.BackgroundColor = [0.7804 0.9294 0.6784];
app.CreateProcessingJobButton.Layout.Row = 14;
app.CreateProcessingJobButton.Layout.Column = [2 3];
app.CreateProcessingJobButton.Text = 'Register Recording';
app.CreateProcessingJobButton.ButtonPushedFcn = createCallbackFcn(app, @createRecordingButton, true);

%%%%%%%%%%%%%%%%%%%%%%%%  TAB2       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create AddRecordingProcessingJobTab
app.SelectRecordingParametersTab = uitab(app.TabGroup);
app.SelectRecordingParametersTab.Title = 'Select Parameters';


% Create GridLayout3
app.GridLayout3 = uigridlayout(app.SelectRecordingParametersTab);
app.GridLayout3.ColumnWidth = {'1x', '2x', '2x', '1x', '1x', '1x', '1x'};
app.GridLayout3.RowHeight = {'1x', '1x', '1x', '1x', '1x', 2, '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

% Create Select Pre-Params List
app.SelectPreParamsListLabel = uilabel(app.GridLayout3);
app.SelectPreParamsListLabel.FontSize = 16;
app.SelectPreParamsListLabel.FontWeight = 'bold';
app.SelectPreParamsListLabel.Layout.Row = 1;
app.SelectPreParamsListLabel.Layout.Column = [1 2];
app.SelectPreParamsListLabel.Text = '1. Select Pre-Params List';

% Create SamePreParamListRecordingCheckBox
app.SamePreParamListRecordingCheckBox = uicheckbox(app.GridLayout3);
app.SamePreParamListRecordingCheckBox.Text = 'Use same pre-params list for all fragments (probe | fov) ? ';
app.SamePreParamListRecordingCheckBox.Layout.Row = 2;
app.SamePreParamListRecordingCheckBox.Layout.Column = [1 2];
app.SamePreParamListRecordingCheckBox.Value = true;
app.SamePreParamListRecordingCheckBox.Enable = 'on';
app.SamePreParamListRecordingCheckBox.ValueChangedFcn = createCallbackFcn(app, @SamePreParamCheckClicked, true);


% Create ListBox Fragments
app.ListBoxFragmentRecording = uilistbox(app.GridLayout3);
app.ListBoxFragmentRecording.Layout.Row = [1 2];
app.ListBoxFragmentRecording.Layout.Column = [3];
app.ListBoxFragmentRecording.Enable = 'off';
app.ListBoxFragmentRecording.Items = {'(Probe|Fov)_0', '(Probe|Fov)_1', '(Probe|Fov)_2', '(Probe|Fov)_3', '(Probe|Fov)_4'};

% Create PreprocessingParamsLabel
app.PreParamListLabel = uilabel(app.GridLayout3);
app.PreParamListLabel.HorizontalAlignment = 'right';
app.PreParamListLabel.Layout.Row = [3];
app.PreParamListLabel.Layout.Column = 1;
app.PreParamListLabel.Text = 'Preprocessing Params Lists';

% Create PreprocessingParamsDropDown
app.PreprocessingParamsDropDown = uidropdown(app.GridLayout3);
app.PreprocessingParamsDropDown.Layout.Row = [3];
app.PreprocessingParamsDropDown.Layout.Column = [2];
%app.PreprocessingParamsDropDown.Items = {};
app.PreprocessingParamsDropDown.ValueChangedFcn = createCallbackFcn(app, @ParamListSelected, true);

% Create ListBox Fragments
app.PreprocessingParamsStepsList = uilistbox(app.GridLayout3);
app.PreprocessingParamsStepsList.Layout.Row = [3 4];
app.PreprocessingParamsStepsList.Layout.Column = [3 4];
app.PreprocessingParamsStepsList.ValueChangedFcn = createCallbackFcn(app, @PreparamStepSelected, true);

% Create Label2
app.Label4 = uilabel(app.GridLayout3);
app.Label4.BackgroundColor = [0 0 0];
app.Label4.Layout.Row = 6;
app.Label4.Layout.Column = [1 4];
app.Label4.Text = 'Label2';

% Create ParamsTextArea
app.ParamsTextArea = uitextarea(app.GridLayout3);
app.ParamsTextArea.Layout.Row = [1 14];
app.ParamsTextArea.Layout.Column = [5 7];

% Create Select Pre-Params List
app.SelectParamsListLabel = uilabel(app.GridLayout3);
app.SelectParamsListLabel.FontSize = 16;
app.SelectParamsListLabel.FontWeight = 'bold';
app.SelectParamsListLabel.Layout.Row = 7;
app.SelectParamsListLabel.Layout.Column = [1 3];
app.SelectParamsListLabel.Text = '2. Select Processing Params';

% Create ListBox Fragments
app.ListBoxFragmentRecording2 = uilistbox(app.GridLayout3);
app.ListBoxFragmentRecording2.Layout.Row = [8 9];
app.ListBoxFragmentRecording2.Layout.Column = [3];
app.ListBoxFragmentRecording2.Enable = 'off';
app.ListBoxFragmentRecording2.Items = {'(Probe|Fov)_0', '(Probe|Fov)_1', '(Probe|Fov)_2', '(Probe|Fov)_3', '(Probe|Fov)_4'};


% Create SamePreParamListRecordingCheckBox
app.SameParamsRecordingCheckBox = uicheckbox(app.GridLayout3);
app.SameParamsRecordingCheckBox.Text = 'Use same processing params for all fragments (probe | fov) ? ';
app.SameParamsRecordingCheckBox.Layout.Row = 8;
app.SameParamsRecordingCheckBox.Layout.Column = [1 3];
app.SameParamsRecordingCheckBox.Value = true;
app.SameParamsRecordingCheckBox.Enable = 'on';
app.SamePreParamListRecordingCheckBox.ValueChangedFcn = createCallbackFcn(app, @SameParamCheckClicked, true);


% Create PreprocessingParamsLabel
app.ParamListLabel = uilabel(app.GridLayout3);
app.ParamListLabel.HorizontalAlignment = 'right';
app.ParamListLabel.Layout.Row = 10;
app.ParamListLabel.Layout.Column = 1;
app.ParamListLabel.Text = 'Processing Params';


% Create ProcessingParamsDropDown
app.ProcessingParamsDropDown = uidropdown(app.GridLayout3);
app.ProcessingParamsDropDown.Layout.Row = 10;
app.ProcessingParamsDropDown.Layout.Column = 2;
app.ProcessingParamsDropDown.Items = {};
%app.ProcessingParamsDropDown.ValueChangedFcn = createCallbackFcn(app, @ParamSetSelected, true);




% Create RecordingDateDatePickerLabel
app.RecordingDateDatePickerLabel = uilabel(app.GridLayout2);
app.RecordingDateDatePickerLabel.HorizontalAlignment = 'right';
app.RecordingDateDatePickerLabel.Layout.Row = 6;
app.RecordingDateDatePickerLabel.Layout.Column = 5;
app.RecordingDateDatePickerLabel.Text = ' Recording Date';
app.RecordingDateDatePickerLabel.Enable = 'off';

% Create RecordingDateDatePicker
app.RecordingDateDatePicker = uidatepicker(app.GridLayout2);
app.RecordingDateDatePicker.Layout.Row = 6;
app.RecordingDateDatePicker.Layout.Column = [6 7];
app.RecordingDateDatePicker.Enable = 'off';


% Create RecordingUserDropDownLabel
app.RecordingUserDropDownLabel = uilabel(app.GridLayout2);
app.RecordingUserDropDownLabel.HorizontalAlignment = 'right';
app.RecordingUserDropDownLabel.Layout.Row = 4;
app.RecordingUserDropDownLabel.Layout.Column = 5;
app.RecordingUserDropDownLabel.Text = 'Recording User';
app.RecordingUserDropDownLabel.Enable = 'off';

% Create RecordingUserDropDown
app.RecordingUserDropDown = uidropdown(app.GridLayout2);
app.RecordingUserDropDown.Layout.Row = 4;
app.RecordingUserDropDown.Layout.Column = [6 7];
app.RecordingUserDropDown.Enable = 'off';
app.RecordingUserDropDown.Items = {};


% Create RecordingTableTab
app.RecordingTableTab = uitab(app.TabGroup);
app.RecordingTableTab.Title = 'Recording Table';

% Create GridLayoutRecTable
app.GridLayoutRT = uigridlayout(app.RecordingTableTab);
app.GridLayoutRT.ColumnWidth = {'1x', '0.5x', '1.5x', '1x', '1.5x', '0.2x', '1x', '1.5x'};
app.GridLayoutRT.RowHeight = {'1x', '1x', '10x'};

% Create FilterprocessingjobLabel
app.FilterRecordingLabel = uilabel(app.GridLayoutRT);
app.FilterRecordingLabel.FontSize = 16;
app.FilterRecordingLabel.FontWeight = 'bold';
app.FilterRecordingLabel.Layout.Row = 1;
app.FilterRecordingLabel.Layout.Column = [1 2];
app.FilterRecordingLabel.Text = '1. Filter recording';


% Create refreshFilterRecTableButton
app.refreshFilterTableButtonRT = uibutton(app.GridLayoutRT, 'push');
app.refreshFilterTableButtonRT.Text = 'Refresh filter';
app.refreshFilterTableButtonRT.Icon = 'reload.png';
app.refreshFilterTableButtonRT.Layout.Row = 2;
app.refreshFilterTableButtonRT.Layout.Column = 1;
app.refreshFilterTableButtonRT.ButtonPushedFcn = createCallbackFcn(app, @filterTable, true);

% Create UserDropDownRTLabel
app.UserDropDownRTLabel = uilabel(app.GridLayoutRT);
app.UserDropDownRTLabel.HorizontalAlignment = 'right';
app.UserDropDownRTLabel.Layout.Row = 2;
app.UserDropDownRTLabel.Layout.Column = 2;
app.UserDropDownRTLabel.Text = 'User';

% Create UserDropDownRT
app.UserDropDownRT = uidropdown(app.GridLayoutRT);
app.UserDropDownRT.Layout.Row = 2;
app.UserDropDownRT.Layout.Column = 3;
app.UserDropDownRT.Items = {};
app.UserDropDownRT.ValueChangedFcn = createCallbackFcn(app, @filterTable, true);


% Create SubjectDropDownRTLabel
app.SubjectDropDownRTLabel = uilabel(app.GridLayoutRT);
app.SubjectDropDownRTLabel.HorizontalAlignment = 'right';
app.SubjectDropDownRTLabel.Layout.Row = 2;
app.SubjectDropDownRTLabel.Layout.Column = 4;
app.SubjectDropDownRTLabel.Text = 'Subject';
app.SubjectDropDownRTLabel.Enable = 'off';

% Create SubjectDropDownRT
app.SubjectDropDownRT = uidropdown(app.GridLayoutRT);
app.SubjectDropDownRT.Layout.Row = 2;
app.SubjectDropDownRT.Layout.Column = 5;
app.SubjectDropDownRT.Items = {};
app.SubjectDropDownRT.ValueChangedFcn = createCallbackFcn(app, @filterTable, true);

% Create DateDatePickerLabelRT
app.DateDatePickerRTLabel = uilabel(app.GridLayoutRT);
app.DateDatePickerRTLabel.HorizontalAlignment = 'right';
app.DateDatePickerRTLabel.Layout.Row = 2;
app.DateDatePickerRTLabel.Layout.Column = 7;
app.DateDatePickerRTLabel.Text = 'Date';

% Create DateDatePickerRT
app.DateDatePickerRT = uidatepicker(app.GridLayoutRT);
app.DateDatePickerRT.Layout.Row = 2;
app.DateDatePickerRT.Layout.Column = 8;
app.DateDatePickerRT.ValueChangedFcn = createCallbackFcn(app, @filterTable, true);

% Create UITableRT
app.UITableRT = uitable(app.GridLayoutRT);
app.UITableRT.ColumnName     = app.COLUMNS_NAMES_RT;
app.UITableRT.ColumnEditable = app.COLUMNS_EDITABLE_RT;
app.UITableRT.ColumnFormat   = app.COLUMNS_FORMAT_RT;
app.UITableRT.ColumnSortable = app.COLUMNS_SORTABLE_RT;
app.UITableRT.RowName = {};
app.UITableRT.Layout.Row = 3;
app.UITableRT.Layout.Column = [1 8];
app.UITableRT.ColumnWidth = 'auto';

% Create ManageProcessingJobsTab
app.ManageProcessingJobsTab = uitab(app.TabGroup);
app.ManageProcessingJobsTab.Title = 'Manage Processing Jobs';

% Create GridLayout3
app.GridLayout3 = uigridlayout(app.ManageProcessingJobsTab);
app.GridLayout3.ColumnWidth = {'1x', '0.5x', '1.5x', '1x', '1.5x', '0.2x', '1x', '1.5x'};
app.GridLayout3.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', 2, '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

% Create FilterprocessingjobLabel
app.FilterprocessingjobLabel = uilabel(app.GridLayout3);
app.FilterprocessingjobLabel.FontSize = 16;
app.FilterprocessingjobLabel.FontWeight = 'bold';
app.FilterprocessingjobLabel.Layout.Row = 1;
app.FilterprocessingjobLabel.Layout.Column = [1 2];
app.FilterprocessingjobLabel.Text = '1. Filter processing job';


% Create refreshFilterTableButton
app.refreshFilterTableButton = uibutton(app.GridLayout3, 'push');
app.refreshFilterTableButton.Text = 'Refresh filter';
app.refreshFilterTableButton.Icon = 'reload.png';
app.refreshFilterTableButton.Layout.Row = 2;
app.refreshFilterTableButton.Layout.Column = 1;
app.refreshFilterTableButton.ButtonPushedFcn = createCallbackFcn(app, @filterTable, true);

% Create UserDropDownLabel
app.UserDropDownLabel = uilabel(app.GridLayout3);
app.UserDropDownLabel.HorizontalAlignment = 'right';
app.UserDropDownLabel.Layout.Row = 2;
app.UserDropDownLabel.Layout.Column = 2;
app.UserDropDownLabel.Text = 'User';

% Create UserDropDown
app.UserDropDown = uidropdown(app.GridLayout3);
app.UserDropDown.Layout.Row = 2;
app.UserDropDown.Layout.Column = 3;
app.UserDropDown.Items = {};
app.UserDropDown.ValueChangedFcn = createCallbackFcn(app, @filterTable, true);

% Create SubjectDropDown_2Label
app.SubjectDropDown_2Label = uilabel(app.GridLayout3);
app.SubjectDropDown_2Label.HorizontalAlignment = 'right';
app.SubjectDropDown_2Label.Layout.Row = 2;
app.SubjectDropDown_2Label.Layout.Column = 4;
app.SubjectDropDown_2Label.Text = 'Subject';
app.SubjectDropDown_2Label.Enable = 'off';

% Create SubjectDropDown_2
app.SubjectDropDown_2 = uidropdown(app.GridLayout3);
app.SubjectDropDown_2.Layout.Row = 2;
app.SubjectDropDown_2.Layout.Column = 5;
app.SubjectDropDown_2.Items = {};
app.SubjectDropDown_2.ValueChangedFcn = createCallbackFcn(app, @filterTable, true);

% Create DateDatePickerLabel
app.DateDatePickerLabel = uilabel(app.GridLayout3);
app.DateDatePickerLabel.HorizontalAlignment = 'right';
app.DateDatePickerLabel.Layout.Row = 2;
app.DateDatePickerLabel.Layout.Column = 7;
app.DateDatePickerLabel.Text = 'Date';

% Create DateDatePicker
app.DateDatePicker = uidatepicker(app.GridLayout3);
app.DateDatePicker.Layout.Row = 2;
app.DateDatePicker.Layout.Column = 8;
app.DateDatePicker.ValueChangedFcn = createCallbackFcn(app, @filterTable, true);

% Create UITable
app.UITable = uitable(app.GridLayout3);
app.UITable.ColumnName     = app.COLUMNS_NAMES;
app.UITable.ColumnEditable = app.COLUMNS_EDITABLE;
app.UITable.ColumnFormat   = app.COLUMNS_FORMAT;
app.UITable.ColumnSortable = app.COLUMNS_SORTABLE;
app.UITable.RowName = {};
app.UITable.Layout.Row = [3 6];
app.UITable.Layout.Column = [1 8];
app.UITable.ColumnWidth = 'auto';

% Create EditselectedjobButton
app.EditselectedjobButton = uibutton(app.GridLayout3, 'push');
app.EditselectedjobButton.BackgroundColor = [1 0.8784 0.6706];
app.EditselectedjobButton.Layout.Row = 7;
app.EditselectedjobButton.Layout.Column = [4 5];
app.EditselectedjobButton.Text = 'Edit selected job';
app.EditselectedjobButton.Enable = 'off';

% Create CreatenewjobforselectedrecordingButton
app.CreatenewjobforselectedrecordingButton = uibutton(app.GridLayout3, 'push');
app.CreatenewjobforselectedrecordingButton.BackgroundColor = [0.9412 0.9804 0.6745];
app.CreatenewjobforselectedrecordingButton.Layout.Row = 7;
app.CreatenewjobforselectedrecordingButton.Layout.Column = [7 8];
app.CreatenewjobforselectedrecordingButton.Text = 'Create new job for selected recording';
app.CreatenewjobforselectedrecordingButton.Enable = 'off';

% Create SetParamstoeditcreatejobprocessingLabel
app.SetParamstoeditcreatejobprocessingLabel = uilabel(app.GridLayout3);
app.SetParamstoeditcreatejobprocessingLabel.FontSize = 16;
app.SetParamstoeditcreatejobprocessingLabel.FontWeight = 'bold';
app.SetParamstoeditcreatejobprocessingLabel.Layout.Row = 9;
app.SetParamstoeditcreatejobprocessingLabel.Layout.Column = [1 4];
app.SetParamstoeditcreatejobprocessingLabel.Text = '2. Set Params to edit/create job processing';
app.SetParamstoeditcreatejobprocessingLabel.Enable = 'off';

% Create IstherebehaviorSessionCheckBox_2
app.IstherebehaviorSessionCheckBox_2 = uicheckbox(app.GridLayout3);
app.IstherebehaviorSessionCheckBox_2.Text = 'Is there Behavior Session for Recording';
app.IstherebehaviorSessionCheckBox_2.Layout.Row = 10;
app.IstherebehaviorSessionCheckBox_2.Layout.Column = [1 4];
app.IstherebehaviorSessionCheckBox_2.Value = true;
app.IstherebehaviorSessionCheckBox_2.ValueChangedFcn = createCallbackFcn(app, @checkBoxSessionRecording, true);
app.IstherebehaviorSessionCheckBox_2.Enable = 'off';

% Create BehaviorSessionDropDown_2Label
app.BehaviorSessionDropDown_2Label = uilabel(app.GridLayout3);
app.BehaviorSessionDropDown_2Label.HorizontalAlignment = 'right';
app.BehaviorSessionDropDown_2Label.Layout.Row = 11;
app.BehaviorSessionDropDown_2Label.Layout.Column = 1;
app.BehaviorSessionDropDown_2Label.Text = 'Behavior Session';
app.BehaviorSessionDropDown_2Label.Enable = 'off';


% Create BehaviorSessionDropDown_2
app.BehaviorSessionDropDown_2 = uidropdown(app.GridLayout3);
app.BehaviorSessionDropDown_2.Layout.Row = 11;
app.BehaviorSessionDropDown_2.Layout.Column = [2 4];
app.BehaviorSessionDropDown_2.Items = {};
app.BehaviorSessionDropDown_2.Enable = 'off';

% Create RecordingSubjectDropDown_2Label
app.RecordingSubjectDropDown_2Label = uilabel(app.GridLayout3);
app.RecordingSubjectDropDown_2Label.HorizontalAlignment = 'right';
app.RecordingSubjectDropDown_2Label.Layout.Row = 10;
app.RecordingSubjectDropDown_2Label.Layout.Column = [5 6];
app.RecordingSubjectDropDown_2Label.Text = 'Recording Subject';
app.RecordingSubjectDropDown_2Label.Enable = 'off';

% Create RecordingSubjectDropDown_2
app.RecordingSubjectDropDown_2 = uidropdown(app.GridLayout3);
app.RecordingSubjectDropDown_2.Layout.Row = 10;
app.RecordingSubjectDropDown_2.Layout.Column = [7 8];
app.RecordingSubjectDropDown_2.Enable = 'off';
app.RecordingSubjectDropDown_2.Items = {};

% Create RecordingDateDatePicker_2Label
app.RecordingDateDatePicker_2Label = uilabel(app.GridLayout3);
app.RecordingDateDatePicker_2Label.HorizontalAlignment = 'right';
app.RecordingDateDatePicker_2Label.Layout.Row = 11;
app.RecordingDateDatePicker_2Label.Layout.Column = [5 6];
app.RecordingDateDatePicker_2Label.Text = 'Recording Date';
app.RecordingDateDatePicker_2Label.Enable = 'off';

% Create RecordingDateDatePicker_2
app.RecordingDateDatePicker_2 = uidatepicker(app.GridLayout3);
app.RecordingDateDatePicker_2.Layout.Row = 11;
app.RecordingDateDatePicker_2.Layout.Column = [7 8];
app.RecordingDateDatePicker_2.Enable = 'off';

% Create PreprocessingParamsDropDown_2Label
app.PreprocessingParamsDropDown_2Label = uilabel(app.GridLayout3);
app.PreprocessingParamsDropDown_2Label.HorizontalAlignment = 'right';
app.PreprocessingParamsDropDown_2Label.Layout.Row = 12;
app.PreprocessingParamsDropDown_2Label.Layout.Column = 1;
app.PreprocessingParamsDropDown_2Label.Text = 'Preprocessing Params';
app.PreprocessingParamsDropDown_2Label.Enable = 'off';

% Create PreprocessingParamsDropDown_2
app.PreprocessingParamsDropDown_2 = uidropdown(app.GridLayout3);
app.PreprocessingParamsDropDown_2.Layout.Row = 12;
app.PreprocessingParamsDropDown_2.Layout.Column = [2 4];
app.PreprocessingParamsDropDown_2.Items = {};
app.PreprocessingParamsDropDown_2.ValueChangedFcn = createCallbackFcn(app, @ParamsSelected, true);
app.PreprocessingParamsDropDown_2.Enable = 'off';

% Create ProcessingParamsDropDown_2Label
app.ProcessingParamsDropDown_2Label = uilabel(app.GridLayout3);
app.ProcessingParamsDropDown_2Label.HorizontalAlignment = 'right';
app.ProcessingParamsDropDown_2Label.Layout.Row = 13;
app.ProcessingParamsDropDown_2Label.Layout.Column = 1;
app.ProcessingParamsDropDown_2Label.Text = 'Processing Params';
app.ProcessingParamsDropDown_2Label.Enable = 'off';

% Create ProcessingParamsDropDown_2
app.ProcessingParamsDropDown_2 = uidropdown(app.GridLayout3);
app.ProcessingParamsDropDown_2.Layout.Row = 13;
app.ProcessingParamsDropDown_2.Layout.Column = [2 4];
app.ProcessingParamsDropDown_2.Items = {};
app.ProcessingParamsDropDown_2.ValueChangedFcn = createCallbackFcn(app, @ParamsSelected, true);
app.ProcessingParamsDropDown_2.Enable = 'off';


% Create TextArea_2
app.TextArea_2 = uitextarea(app.GridLayout3);
app.TextArea_2.Layout.Row = [12 15];
app.TextArea_2.Layout.Column = [5 8];
app.TextArea_2.Enable = 'off';

% Create AcceptEditionCreationButton
app.AcceptEditionCreationButton = uibutton(app.GridLayout3, 'push');
app.AcceptEditionCreationButton.BackgroundColor = [0.7804 0.9294 0.6784];
app.AcceptEditionCreationButton.Layout.Row = 15;
app.AcceptEditionCreationButton.Layout.Column = [2 4];
app.AcceptEditionCreationButton.Text = 'Accept Edition/Creation';
app.AcceptEditionCreationButton.Enable = 'off';

% Create Label3
app.Label3 = uilabel(app.GridLayout3);
app.Label3.BackgroundColor = [0 0 0];
app.Label3.Layout.Row = 8;
app.Label3.Layout.Column = [1 8];
app.Label3.Text = 'Label3';

% Create RecordingUserDropDown_2Label
app.RecordingUserDropDown_2Label = uilabel(app.GridLayout3);
app.RecordingUserDropDown_2Label.HorizontalAlignment = 'right';
app.RecordingUserDropDown_2Label.Layout.Row = 9;
app.RecordingUserDropDown_2Label.Layout.Column = [5 6];
app.RecordingUserDropDown_2Label.Text = 'Recording User';
app.RecordingUserDropDown_2Label.Enable = 'off';

% Create RecordingUserDropDown_2
app.RecordingUserDropDown_2 = uidropdown(app.GridLayout3);
app.RecordingUserDropDown_2.Layout.Row = 9;
app.RecordingUserDropDown_2.Layout.Column = [7 8];
app.RecordingUserDropDown_2.Enable = 'off';
app.RecordingUserDropDown_2.Items = {};

% Create SystemSetUpTab
app.SystemSetUpTab = uitab(app.TabGroup);
app.SystemSetUpTab.Title = 'System Configuration';

% Create GridLayout
app.GridLayout = uigridlayout(app.SystemSetUpTab);
app.GridLayout.ColumnWidth = {'1.5x', '1x', '1x', '1x', '1x', '1x', '0.2x'};
app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

% Create SystemNameDropDownLabel
app.SystemNameDropDownLabel = uilabel(app.GridLayout);
app.SystemNameDropDownLabel.HorizontalAlignment = 'right';
app.SystemNameDropDownLabel.FontSize = 14;
app.SystemNameDropDownLabel.Enable = 'off';
app.SystemNameDropDownLabel.Layout.Row = 3;
app.SystemNameDropDownLabel.Layout.Column = 1;
app.SystemNameDropDownLabel.Text = 'System Name';

% Create SystemNameDropDown
app.SystemNameDropDown = uidropdown(app.GridLayout);
app.SystemNameDropDown.Enable = 'off';
app.SystemNameDropDown.Layout.Row = 3;
app.SystemNameDropDown.Layout.Column = [2 4];
app.SystemNameDropDown.Items = {};

% Create RecordingModalityDropDownLabel
app.RecordingModalityDropDownLabel = uilabel(app.GridLayout);
app.RecordingModalityDropDownLabel.HorizontalAlignment = 'right';
app.RecordingModalityDropDownLabel.FontSize = 14;
app.RecordingModalityDropDownLabel.Enable = 'off';
app.RecordingModalityDropDownLabel.Layout.Row = 5;
app.RecordingModalityDropDownLabel.Layout.Column = 1;
app.RecordingModalityDropDownLabel.Text = 'Recording Modality';

% Create RecordingModalityDropDown
app.RecordingModalityDropDown = uidropdown(app.GridLayout);
app.RecordingModalityDropDown.Enable = 'off';
app.RecordingModalityDropDown.Layout.Row = 5;
app.RecordingModalityDropDown.Layout.Column = [2 4];
app.RecordingModalityDropDown.Items = {};

% Create RecordingRootDirectoryEditLabel
app.RecordingRootDirectoryEditLabel = uilabel(app.GridLayout);
app.RecordingRootDirectoryEditLabel.HorizontalAlignment = 'right';
app.RecordingRootDirectoryEditLabel.FontSize = 14;
app.RecordingRootDirectoryEditLabel.Enable = 'off';
app.RecordingRootDirectoryEditLabel.Layout.Row = 6;
app.RecordingRootDirectoryEditLabel.Layout.Column = 1;
app.RecordingRootDirectoryEditLabel.Text = 'Recording Root Folder';

% Create RecordingRootDirectoryEdit
app.RecordingRootDirectoryEdit = uieditfield(app.GridLayout, 'text');
app.RecordingRootDirectoryEdit.Enable = 'off';
app.RecordingRootDirectoryEdit.Layout.Row = 6;
app.RecordingRootDirectoryEdit.Layout.Column = [2 6];

% Create AssociatedBehaviorRigDropDownLabel
app.AssociatedBehaviorRigDropDownLabel = uilabel(app.GridLayout);
app.AssociatedBehaviorRigDropDownLabel.HorizontalAlignment = 'right';
app.AssociatedBehaviorRigDropDownLabel.FontSize = 14;
app.AssociatedBehaviorRigDropDownLabel.Enable = 'off';
app.AssociatedBehaviorRigDropDownLabel.Layout.Row = 4;
app.AssociatedBehaviorRigDropDownLabel.Layout.Column = 1;
app.AssociatedBehaviorRigDropDownLabel.Text = 'Associated Behavior Rig';

% Create AssociatedBehaviorRigDropDown
app.AssociatedBehaviorRigDropDown = uidropdown(app.GridLayout);
app.AssociatedBehaviorRigDropDown.Enable = 'off';
app.AssociatedBehaviorRigDropDown.Layout.Row = 4;
app.AssociatedBehaviorRigDropDown.Layout.Column = [2 4];
app.AssociatedBehaviorRigDropDown.Items = {};

% Create ConfigurationOptionsLabel
app.ConfigurationOptionsLabel = uilabel(app.GridLayout);
app.ConfigurationOptionsLabel.FontSize = 16;
app.ConfigurationOptionsLabel.FontWeight = 'bold';
app.ConfigurationOptionsLabel.Layout.Row = 1;
app.ConfigurationOptionsLabel.Layout.Column = [1 3];
app.ConfigurationOptionsLabel.Text = '1. Configuration Options';

% Create ConfigureSystemButton
app.ConfigureSystemButton = uibutton(app.GridLayout, 'push');
app.ConfigureSystemButton.BackgroundColor = [0.9176 0.9882 0.851];
app.ConfigureSystemButton.FontWeight = 'bold';
app.ConfigureSystemButton.Layout.Row = 8;
app.ConfigureSystemButton.Layout.Column = [2 5];
app.ConfigureSystemButton.Text = 'Configure System';
app.ConfigureSystemButton.Enable = 'off';
app.ConfigureSystemButton.ButtonPushedFcn = createCallbackFcn(app, @configureSystem, true);

% Create SystemLabel
app.SystemLabel = uilabel(app.GridLayout);
app.SystemLabel.Layout.Row = 3;
app.SystemLabel.Layout.Column = 5;
app.SystemLabel.Text = '';

% Create BehaviorRigLabel
app.BehaviorRigLabel = uilabel(app.GridLayout);
app.BehaviorRigLabel.Layout.Row = 4;
app.BehaviorRigLabel.Layout.Column = 5;
app.BehaviorRigLabel.Text = '';

% Create RecordingModalityLabel
app.RecordingModalityLabel = uilabel(app.GridLayout);
app.RecordingModalityLabel.Layout.Row = 5;
app.RecordingModalityLabel.Layout.Column = 5;
app.RecordingModalityLabel.Text = '';

% Create RecordingRootDirectoryLabel
app.RecordingRootDirectoryLabel = uilabel(app.GridLayout);
app.RecordingRootDirectoryLabel.Layout.Row = 7;
app.RecordingRootDirectoryLabel.Layout.Column = [2 6];
app.RecordingRootDirectoryLabel.Text = '';

% Create BusyLabel
app.BusyLabel = uilabel(app.GridLayout4);
app.BusyLabel.BackgroundColor = [0.7608 1 0.7922];
app.BusyLabel.HorizontalAlignment = 'center';
app.BusyLabel.FontSize = 14;
app.BusyLabel.Layout.Row = [1 2];
app.BusyLabel.Layout.Column = 5;
app.BusyLabel.Text = 'OK';

% Create ConfigurationNeededLabel
app.ConfigurationNeededLabel = uilabel(app.GridLayout4);
app.ConfigurationNeededLabel.BackgroundColor = 'none';
app.ConfigurationNeededLabel.HorizontalAlignment = 'center';
app.ConfigurationNeededLabel.FontSize = 13;
app.ConfigurationNeededLabel.Layout.Row = [1];
app.ConfigurationNeededLabel.Layout.Column = 4;
app.ConfigurationNeededLabel.Text = '';

% Create StartConfigurationButton
app.StartConfigurationButton = uibutton(app.GridLayout, 'push');
app.StartConfigurationButton.BackgroundColor = [0.8118 0.9176 0.9804];
app.StartConfigurationButton.FontWeight = 'bold';
app.StartConfigurationButton.Layout.Row = 2;
app.StartConfigurationButton.Layout.Column = [2 5];
app.StartConfigurationButton.Text = 'Start Configuration';
app.StartConfigurationButton.ButtonPushedFcn = createCallbackFcn(app, @startConfiguration, true);

% Create SearchDirectoryButton
app.SearchDirectoryButton = uibutton(app.GridLayout, 'push');
app.SearchDirectoryButton.Icon = 'OneDrive_Folder_Icon.svg.png';
app.SearchDirectoryButton.Layout.Row = 6;
app.SearchDirectoryButton.Layout.Column = 7;
app.SearchDirectoryButton.Text = '';
app.SearchDirectoryButton.Enable = 'off';
app.SearchDirectoryButton.ButtonPushedFcn = createCallbackFcn(app, @selectRecordingRootDirectory, true);

% Show the figure after all components are created
movegui(app.UIFigure, 'center')
app.UIFigure.Visible = 'on';
end

