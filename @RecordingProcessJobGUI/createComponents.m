function createComponents(app)

% Create UIFigure and hide until all components are created
app.UIFigure = uifigure('Visible', 'off');
screenSize = get(groot,'ScreenSize');
percentage_screen = 90;
ratio = percentage_screen/100;
offset = (1-ratio)/2;

app.UIFigure.Position = [screenSize(3)*offset screenSize(4)*offset ...
                         screenSize(3)*ratio screenSize(4)*ratio];
app.UIFigure.Name = 'U19 Automatic Processing Pipeline GUI';

% Create GridLayout4
app.GridLayout4 = uigridlayout(app.UIFigure);
app.GridLayout4.ColumnWidth = {'1x', '4x', '4x', '1.5x', '1.5x'};
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

% Create BusyLabel
app.BusyLabel = uilabel(app.GridLayout4);
app.BusyLabel.BackgroundColor = [0.7608 1 0.7922];
app.BusyLabel.FontWeight = 'bold';
app.BusyLabel.HorizontalAlignment = 'center';
app.BusyLabel.FontSize = 14;
app.BusyLabel.Layout.Row = [1 2];
app.BusyLabel.Layout.Column = 4;
app.BusyLabel.Text = 'OK';

% Create ConfigurationNeededLabel
app.ConfigurationNeededLabel = uilabel(app.GridLayout4);
app.ConfigurationNeededLabel.BackgroundColor = 'none';
app.ConfigurationNeededLabel.HorizontalAlignment = 'center';
app.ConfigurationNeededLabel.FontSize = 13;
app.ConfigurationNeededLabel.Layout.Row = [1 2];
app.ConfigurationNeededLabel.Layout.Column = 5;
app.ConfigurationNeededLabel.Text = '';
app.ConfigurationNeededLabel.FontWeight = 'bold';


%%%%%%%%%%%%%%%%%%%%%%%%  TAB1       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create AddRecordingProcessingJobTab
app.AddRecordingProcessingJobTab = uitab(app.TabGroup);
app.AddRecordingProcessingJobTab.Title = 'Add Recording';


% Create GridLayout2
app.GridLayout2 = uigridlayout(app.AddRecordingProcessingJobTab);
app.GridLayout2.ColumnWidth = {'1.5x', '1x', '1x', '1x', '1x', '1x', '1x'};
app.GridLayout2.RowHeight = {'1x', '2x', 2, '1x', '2x', '2x', 2, '1x', '1x', '2x', '1x', 1 '1x', '2x', '3x'};

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
app.RecordingDirectoryDropDownLabel.FontWeight = 'bold';
app.RecordingDirectoryDropDownLabel.Layout.Row = 2;
app.RecordingDirectoryDropDownLabel.Layout.Column = 1;
app.RecordingDirectoryDropDownLabel.Text = 'Recording Directory: ';

% Create RecordingDirectoryDropDown
app.RecordingDirectoryDropDown = uidropdown(app.GridLayout2);
app.RecordingDirectoryDropDown.Layout.Row = 2;
app.RecordingDirectoryDropDown.Layout.Column = [2 4];
app.RecordingDirectoryDropDown.Items = {};

% Create SurgeryCheckBox
app.SurgeryCheckBox = uicheckbox(app.GridLayout2);
app.SurgeryCheckBox.Text = 'Add surgery & insertion device if missing ?';
app.SurgeryCheckBox.Layout.Row = 2;
app.SurgeryCheckBox.Layout.Column = [5 7];
app.SurgeryCheckBox.Value = true;
app.SurgeryCheckBox.FontSize = 16;
app.SurgeryCheckBox.Enable = 'on';


% Create IstherebehaviorSessionCheckBox
app.IstherebehaviorSessionCheckBox = uicheckbox(app.GridLayout2);
app.IstherebehaviorSessionCheckBox.Text = 'Is there behavior Session for Recording?';
app.IstherebehaviorSessionCheckBox.Layout.Row = 5;
app.IstherebehaviorSessionCheckBox.Layout.Column = [1 4];
app.IstherebehaviorSessionCheckBox.Value = true;
app.IstherebehaviorSessionCheckBox.ValueChangedFcn = createCallbackFcn(app, @checkBoxSessionRecording, true);
app.IstherebehaviorSessionCheckBox.Enable = 'on';


% Create BehaviorSessionDropDownLabel
app.BehaviorSessionDropDownLabel = uilabel(app.GridLayout2);
app.BehaviorSessionDropDownLabel.HorizontalAlignment = 'right';
app.BehaviorSessionDropDownLabel.FontWeight = 'bold';
app.BehaviorSessionDropDownLabel.Layout.Row = 6;
app.BehaviorSessionDropDownLabel.Layout.Column = 1;
app.BehaviorSessionDropDownLabel.Text = 'Behavior Session:';

% Create BehaviorSessionDropDown
app.BehaviorSessionDropDown = uidropdown(app.GridLayout2);
app.BehaviorSessionDropDown.Layout.Row = 6;
app.BehaviorSessionDropDown.Layout.Column = [2 4];
app.BehaviorSessionDropDown.Items = {};

% Create RecordingUserDropDownLabel
%app.RecordingUserDropDownLabel = uilabel(app.GridLayout2);
%app.RecordingUserDropDownLabel.HorizontalAlignment = 'right';
%app.RecordingUserDropDownLabel.Layout.Row = 4;
%app.RecordingUserDropDownLabel.Layout.Column = 5;
%app.RecordingUserDropDownLabel.Text = 'Recording User';
%app.RecordingUserDropDownLabel.Enable = 'off';

% Create RecordingUserDropDown
%app.RecordingUserDropDown = uidropdown(app.GridLayout2);
%app.RecordingUserDropDown.Layout.Row = 4;
%app.RecordingUserDropDown.Layout.Column = [6 7];
%app.RecordingUserDropDown.Enable = 'off';
%app.RecordingUserDropDown.Items = {};

% Create RecordingSubjectDropDownLabel
app.RecordingSubjectDropDownLabel = uilabel(app.GridLayout2);
app.RecordingSubjectDropDownLabel.HorizontalAlignment = 'right';
app.RecordingSubjectDropDownLabel.Layout.Row = 4;
app.RecordingSubjectDropDownLabel.Layout.Column = 5;
app.RecordingSubjectDropDownLabel.Text = 'Recording Subject';
app.RecordingSubjectDropDownLabel.Enable = 'off';

% Create RecordingSubjectDropDown_2
app.RecordingSubjectDropDown = uidropdown(app.GridLayout2);
app.RecordingSubjectDropDown.Layout.Row = 4;
app.RecordingSubjectDropDown.Layout.Column = [6 7];
app.RecordingSubjectDropDown.Enable = 'off';
app.RecordingSubjectDropDown.Items = {};

% Create RecordingDateDatePickerLabel
app.RecordingDateDatePickerLabel = uilabel(app.GridLayout2);
app.RecordingDateDatePickerLabel.HorizontalAlignment = 'right';
app.RecordingDateDatePickerLabel.Layout.Row = 5;
app.RecordingDateDatePickerLabel.Layout.Column = 5;
app.RecordingDateDatePickerLabel.Text = ' Recording Date';
app.RecordingDateDatePickerLabel.Enable = 'off';

% Create RecordingDateDatePicker
app.RecordingDateDatePicker = uidatepicker(app.GridLayout2);
app.RecordingDateDatePicker.Layout.Row = 5;
app.RecordingDateDatePicker.Layout.Column = [6 7];
app.RecordingDateDatePicker.Enable = 'off';

% Create RecordingDateDatePickerLabel
app.RecordingDateTimePickerLabel = uilabel(app.GridLayout2);
app.RecordingDateTimePickerLabel.HorizontalAlignment = 'right';
app.RecordingDateTimePickerLabel.Layout.Row = 6;
app.RecordingDateTimePickerLabel.Layout.Column = 5;
app.RecordingDateTimePickerLabel.Text = ' Recording Hour (0-24)';
app.RecordingDateTimePickerLabel.Enable = 'off';

% Create RecordingDateDatePicker
app.RecordingDateTimePicker = uispinner(app.GridLayout2);
app.RecordingDateTimePicker.Layout.Row = 6;
app.RecordingDateTimePicker.Layout.Column = [6 7];
app.RecordingDateTimePicker.Enable = 'off';


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
app.SelectProcessingParametersLabel.Layout.Column = [1 2];
app.SelectProcessingParametersLabel.Text = '3. Select Processing Parameters';


% Create DefaultParametersCheckBox
app.DefaultParametersCheckBox = uicheckbox(app.GridLayout2);
app.DefaultParametersCheckBox.Text = 'Use default processing parameters for recording ? ';
app.DefaultParametersCheckBox.FontSize = 17;
app.DefaultParametersCheckBox.Layout.Row = 8;
app.DefaultParametersCheckBox.Layout.Column = [3 4];
app.DefaultParametersCheckBox.Value = true;
app.DefaultParametersCheckBox.Enable = 'on';
app.DefaultParametersCheckBox.ValueChangedFcn = createCallbackFcn(app, @DefaultParamsCheckBoxToggle, true);
%app.DefaultParametersCheckBox.HorizontalAlignment = 'right';

% Create DefaultParametersCheckBox
app.DefaultParametersLabel = uilabel(app.GridLayout2);
app.DefaultParametersLabel.Text = '<<< Uncheck this if you want to select another set of parameters for the recording';
app.DefaultParametersLabel.FontSize = 17;
app.DefaultParametersLabel.Layout.Row = 8;
app.DefaultParametersLabel.Layout.Column = [5 7];
app.DefaultParametersLabel.Layout.Column = [5 7];
app.DefaultParametersLabel.FontColor = app.NotifyColor;
app.DefaultParametersLabel.HorizontalAlignment = 'left';
app.DefaultParametersLabel.VerticalAlignment = 'center';

% Create PreprocessingParamsLabel
app.DefaultPreParamNameLabel = uilabel(app.GridLayout2);
app.DefaultPreParamNameLabel.HorizontalAlignment = 'left';
app.DefaultPreParamNameLabel.VerticalAlignment = 'bottom';
app.DefaultPreParamNameLabel.FontWeight = 'bold';
app.DefaultPreParamNameLabel.FontSize = 14;
app.DefaultPreParamNameLabel.Layout.Row = 9;
app.DefaultPreParamNameLabel.Layout.Column = [1 3];
app.DefaultPreParamNameLabel.Text = 'Default Preprocess Parameters Steps: ';

app.DefaultPreParamTable = uitable(app.GridLayout2);
app.DefaultPreParamTable.ColumnName     = app.COLUMNS_DEF_PREPARAMS_NAMES;
app.DefaultPreParamTable.ColumnFormat   = app.COLUMNS_DEF_PREPARAMS_FORMAT;
app.DefaultPreParamTable.ColumnSortable = app.COLUMNS_DEF_PREPARAMS_SORTABLE;
app.DefaultPreParamTable.ColumnEditable = app.COLUMNS_DEF_PREPARAMS_EDITABLE;
app.DefaultPreParamTable.RowName = {};
app.DefaultPreParamTable.Layout.Row = [10 11];
app.DefaultPreParamTable.Layout.Column = [1 7];
app.DefaultPreParamTable.ColumnWidth = 'auto';

% Create Label
app.Label0 = uilabel(app.GridLayout2);
app.Label0.BackgroundColor = [0 0 0];
app.Label0.Layout.Row = 12;
app.Label0.Layout.Column = [1 7];

% Create PreprocessingParamsLabel
app.DefaultParamNameLabel = uilabel(app.GridLayout2);
app.DefaultParamNameLabel.HorizontalAlignment = 'left';
app.DefaultParamNameLabel.VerticalAlignment = 'bottom';
app.DefaultParamNameLabel.FontWeight = 'bold';
app.DefaultParamNameLabel.FontSize = 14;
app.DefaultParamNameLabel.Layout.Row = 13;
app.DefaultParamNameLabel.Layout.Column = [1 3];
app.DefaultParamNameLabel.Text = 'Default Processing Params: ';

app.DefaultParamTable = uitable(app.GridLayout2);
app.DefaultParamTable.ColumnName     = app.COLUMNS_DEF_PARAMS_NAMES;
app.DefaultParamTable.ColumnFormat   = app.COLUMNS_DEF_PARAMS_FORMAT;
app.DefaultParamTable.ColumnSortable = app.COLUMNS_DEF_PARAMS_SORTABLE;
app.DefaultParamTable.ColumnEditable = app.COLUMNS_DEF_PARAMS_EDITABLE;
app.DefaultParamTable.RowName = {};
app.DefaultParamTable.Layout.Row = [14];
app.DefaultParamTable.Layout.Column = [1 7];
app.DefaultParamTable.ColumnWidth = 'auto';



% Create CreateProcessingJobButton
app.CreateProcessingJobButton = uibutton(app.GridLayout2, 'push');
app.CreateProcessingJobButton.BackgroundColor = app.GreenBColor;
app.CreateProcessingJobButton.FontWeight = 'bold';
app.CreateProcessingJobButton.FontSize = 19;
app.CreateProcessingJobButton.Layout.Row = 15;
app.CreateProcessingJobButton.Layout.Column = [5 7];
app.CreateProcessingJobButton.Text = 'Register Recording';
app.CreateProcessingJobButton.ButtonPushedFcn = createCallbackFcn(app, @createRecordingButton, true);



%%%%%%%%%%%%%%%%%%%%%%%%  TAB2       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create AddRecordingProcessingJobTab
app.SelectRecordingParametersTab = uitab(app.TabGroup);
app.SelectRecordingParametersTab.Title = 'Select Parameters';

% Create GridLayout3
app.GridLayout3 = uigridlayout(app.SelectRecordingParametersTab);
app.GridLayout3.ColumnWidth = {'1x', '2x', '1x', '2x', '1x', '1x', '1x'};
app.GridLayout3.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', 2, '1x', '1x', '1x', '1x', '1x', '1x'};

% Create Select Pre-Params List
app.UserParamsLabel = uilabel(app.GridLayout3);
%app.UserParamsLabel.FontSize = 16;
%app.UserParamsLabel.FontWeight = 'bold';
app.UserParamsLabel.Layout.Row = 1;
app.UserParamsLabel.Layout.Column = [1];
app.UserParamsLabel.Text = 'Def. user params: ';

% Create PreprocessingParamsDropDown
app.UserParamsDropDown = uidropdown(app.GridLayout3);
app.UserParamsDropDown.Layout.Row = [1];
app.UserParamsDropDown.Layout.Column = [2 3];
app.UserParamsDropDown.ValueChangedFcn = createCallbackFcn(app, @fillParams2Select, true);


% Create Select Pre-Params List
app.SelectPreParamsListLabel = uilabel(app.GridLayout3);
app.SelectPreParamsListLabel.FontSize = 16;
app.SelectPreParamsListLabel.FontWeight = 'bold';
app.SelectPreParamsListLabel.Layout.Row = 2;
app.SelectPreParamsListLabel.Layout.Column = [1 2];
app.SelectPreParamsListLabel.Text = '1. Select Preprocessing-Params List';

% Create SamePreParamListRecordingCheckBox
app.SamePreParamListRecordingCheckBox = uicheckbox(app.GridLayout3);
app.SamePreParamListRecordingCheckBox.Text = 'Use same pre-params list for all fragments (probe | fov) ? ';
app.SamePreParamListRecordingCheckBox.Layout.Row = 3;
app.SamePreParamListRecordingCheckBox.Layout.Column = [1 2];
app.SamePreParamListRecordingCheckBox.Value = true;
app.SamePreParamListRecordingCheckBox.Enable = 'on';
app.SamePreParamListRecordingCheckBox.ValueChangedFcn = createCallbackFcn(app, @SamePreParamCheckClicked, true);


% Create ListBox Fragments
app.ListBoxFragmentRecording = uilistbox(app.GridLayout3);
app.ListBoxFragmentRecording.Layout.Row = [2 3];
app.ListBoxFragmentRecording.Layout.Column = [3];
app.ListBoxFragmentRecording.Enable = 'off';
app.ListBoxFragmentRecording.Items = {'(Probe|Fov)_0', '(Probe|Fov)_1', '(Probe|Fov)_2', '(Probe|Fov)_3', '(Probe|Fov)_4'};
app.ListBoxFragmentRecording.ValueChangedFcn = createCallbackFcn(app, @SelectedListBoxFragmentRec, true);


% Create ListBox Fragments (stored lists)
app.ListBoxFragmentRecordingPreParams = uilistbox(app.GridLayout3);
app.ListBoxFragmentRecordingPreParams.Layout.Row = [2 3];
app.ListBoxFragmentRecordingPreParams.Layout.Column = [4];
app.ListBoxFragmentRecordingPreParams.Enable = 'off';
app.ListBoxFragmentRecordingPreParams.Items = {'0', '1', '2', '3', '4'};


% Create PreprocessingParamsLabel
app.PreParamListLabel = uilabel(app.GridLayout3);
app.PreParamListLabel.HorizontalAlignment = 'right';
app.PreParamListLabel.FontWeight = 'bold';
app.PreParamListLabel.Layout.Row = [4];
app.PreParamListLabel.Layout.Column = 1;
app.PreParamListLabel.Text = 'Preprocessing Params Lists: ';

% Create PreprocessingParamsDropDown
app.PreprocessingParamsDropDown = uidropdown(app.GridLayout3);
app.PreprocessingParamsDropDown.Layout.Row = [4];
app.PreprocessingParamsDropDown.Layout.Column = [2];
%app.PreprocessingParamsDropDown.Items = {};
app.PreprocessingParamsDropDown.ValueChangedFcn = createCallbackFcn(app, @ParamListSelected, true);

app.PreParamsDescriptionLabel = uilabel(app.GridLayout3);
app.PreParamsDescriptionLabel.FontSize = 12;
app.PreParamsDescriptionLabel.HorizontalAlignment = 'right';
app.PreParamsDescriptionLabel.FontWeight = 'bold';
app.PreParamsDescriptionLabel.Layout.Row = 5;
app.PreParamsDescriptionLabel.Layout.Column = 1;
app.PreParamsDescriptionLabel.Text = 'Description: ';

app.PreParamsDescriptionLabel2 = uilabel(app.GridLayout3);
app.PreParamsDescriptionLabel2.FontSize = 12;
app.PreParamsDescriptionLabel2.Layout.Row = 5;
app.PreParamsDescriptionLabel2.Layout.Column = 2;
app.PreParamsDescriptionLabel2.Text = '';


app.UserDatePreParamsLabel = uilabel(app.GridLayout3);
app.UserDatePreParamsLabel.FontSize = 12;
app.UserDatePreParamsLabel.HorizontalAlignment = 'right';
app.UserDatePreParamsLabel.FontWeight = 'bold';
app.UserDatePreParamsLabel.Layout.Row = 6;
app.UserDatePreParamsLabel.Layout.Column = 1;
app.UserDatePreParamsLabel.Text = 'User & Date params: ';

app.UserDatePreParamsLabel2 = uilabel(app.GridLayout3);
app.UserDatePreParamsLabel2.FontSize = 12;
%app.UserDatePreParamsLabel2.FontWeight = 'bold';
app.UserDatePreParamsLabel2.Layout.Row = 6;
app.UserDatePreParamsLabel2.Layout.Column = 2;
app.UserDatePreParamsLabel2.Text = '';



% Create ListBox Fragments
app.PreprocessingParamsStepsList = uilistbox(app.GridLayout3);
app.PreprocessingParamsStepsList.Layout.Row = [4 5];
app.PreprocessingParamsStepsList.Layout.Column = [3 4];
app.PreprocessingParamsStepsList.ValueChangedFcn = createCallbackFcn(app, @PreparamStepSelected, true);


% Create SamePreParamListRecordingCheckBox
app.RegisterPreparamsFragment = uibutton(app.GridLayout3);
app.RegisterPreparamsFragment.Text = 'Register (Probe|Fov)_0';
app.RegisterPreparamsFragment.Layout.Row = 6;
app.RegisterPreparamsFragment.Layout.Column = [3 4];
app.RegisterPreparamsFragment.Enable = 'off';
app.RegisterPreparamsFragment.ButtonPushedFcn = createCallbackFcn(app, @RegisterPreparamFragmentClicked, true);

% Create Label2
app.Label4 = uilabel(app.GridLayout3);
app.Label4.BackgroundColor = [0 0 0];
app.Label4.Layout.Row = 7;
app.Label4.Layout.Column = [1 4];
app.Label4.Text = 'Label2';


% Create CreateParamsTextAreaTitle
app.ParamsTextAreaTitle = uilabel(app.GridLayout3);
app.ParamsTextAreaTitle.FontSize = 14;
app.ParamsTextAreaTitle.FontWeight = 'bold';
app.ParamsTextAreaTitle.Layout.Row = 1;
app.ParamsTextAreaTitle.Layout.Column = [5 7];
app.ParamsTextAreaTitle.Text = 'Json viewer:';

% Create ParamsTextArea
app.ParamsTextArea = uitextarea(app.GridLayout3);
app.ParamsTextArea.Layout.Row = [2 14];
app.ParamsTextArea.Layout.Column = [5 7];

% Create Select Pre-Params List
app.SelectParamsListLabel = uilabel(app.GridLayout3);
app.SelectParamsListLabel.FontSize = 16;
app.SelectParamsListLabel.FontWeight = 'bold';
app.SelectParamsListLabel.Layout.Row = 8;
app.SelectParamsListLabel.Layout.Column = [1 3];
app.SelectParamsListLabel.Text = '2. Select Processing Params';

% Create ListBox Fragments
app.ListBoxFragmentRecording2 = uilistbox(app.GridLayout3);
app.ListBoxFragmentRecording2.Layout.Row = [8 9];
app.ListBoxFragmentRecording2.Layout.Column = [3];
app.ListBoxFragmentRecording2.Enable = 'off';
app.ListBoxFragmentRecording2.Items = {'(Probe|Fov)_0', '(Probe|Fov)_1', '(Probe|Fov)_2', '(Probe|Fov)_3', '(Probe|Fov)_4'};
app.ListBoxFragmentRecording2.ValueChangedFcn = createCallbackFcn(app, @SelectedListBoxFragmentRec2, true);



% Create ListBox Fragments (stored lists)
app.ListBoxFragmentRecording2Params = uilistbox(app.GridLayout3);
app.ListBoxFragmentRecording2Params.Layout.Row = [8 9];
app.ListBoxFragmentRecording2Params.Layout.Column = [4];
app.ListBoxFragmentRecording2Params.Enable = 'off';
app.ListBoxFragmentRecording2Params.Items = {'0', '1', '2', '3', '4'};



% Create SamePreParamListRecordingCheckBox
app.SameParamsRecordingCheckBox = uicheckbox(app.GridLayout3);
app.SameParamsRecordingCheckBox.Text = 'Use same processing params for all fragments (probe | fov) ? ';
app.SameParamsRecordingCheckBox.Layout.Row = 9;
app.SameParamsRecordingCheckBox.Layout.Column = [1 2];
app.SameParamsRecordingCheckBox.Value = true;
app.SameParamsRecordingCheckBox.Enable = 'on';
app.SameParamsRecordingCheckBox.ValueChangedFcn = createCallbackFcn(app, @SameParamCheckClicked, true);


% Create PreprocessingParamsLabel
app.ParamListLabel = uilabel(app.GridLayout3);
app.ParamListLabel.HorizontalAlignment = 'right';
app.ParamListLabel.FontWeight = 'bold';
app.ParamListLabel.Layout.Row = 10;
app.ParamListLabel.Layout.Column = 1;
app.ParamListLabel.Text = 'Processing Params: ';


% Create ProcessingParamsDropDown
app.ProcessingParamsDropDown = uidropdown(app.GridLayout3);
app.ProcessingParamsDropDown.Layout.Row = 10;
app.ProcessingParamsDropDown.Layout.Column = [2 3];
app.ProcessingParamsDropDown.Items = {};
app.ProcessingParamsDropDown.ValueChangedFcn = createCallbackFcn(app, @ParamSetSelected, true);

app.UserDateParamsLabel = uilabel(app.GridLayout3);
app.UserDateParamsLabel.FontSize = 12;
app.UserDateParamsLabel.FontWeight = 'bold';
app.UserDateParamsLabel.HorizontalAlignment = 'right';
app.UserDateParamsLabel.Layout.Row = 11;
app.UserDateParamsLabel.Layout.Column = 1;
app.UserDateParamsLabel.Text = 'User & Date params: ';

app.UserDateParamsLabel2 = uilabel(app.GridLayout3);
app.UserDateParamsLabel2.FontSize = 12;
%app.UserDatePreParamsLabel2.FontWeight = 'bold';
app.UserDateParamsLabel2.Layout.Row = 11;
app.UserDateParamsLabel2.Layout.Column = 2;
app.UserDateParamsLabel2.Text = '';

% Create SamePreParamListRecordingCheckBox
app.RegisterParamsFragment = uibutton(app.GridLayout3);
app.RegisterParamsFragment.Text = 'Register (Probe|Fov)_0';
app.RegisterParamsFragment.Layout.Row = 10;
app.RegisterParamsFragment.Layout.Column = 4;
app.RegisterParamsFragment.Enable = 'off';
app.RegisterParamsFragment.ButtonPushedFcn = createCallbackFcn(app, @RegisterParamsFragmentClicked, true);


% Create CreateProcessingJobButton
app.CreateProcessingJobButton2 = uibutton(app.GridLayout3, 'push');
app.CreateProcessingJobButton2.BackgroundColor = app.GreenBColor;
app.CreateProcessingJobButton2.FontSize = 16;
app.CreateProcessingJobButton.FontWeight = 'bold';
app.CreateProcessingJobButton2.Layout.Row = 14;
app.CreateProcessingJobButton2.Layout.Column = [2 4];
app.CreateProcessingJobButton2.Enable = 'off';
app.CreateProcessingJobButton2.Text = 'Register Recording';
app.CreateProcessingJobButton2.ButtonPushedFcn = createCallbackFcn(app, @checkParamSelection, true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TAB3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create RecordingTableTab
app.RecordingTableTab = uitab(app.TabGroup);
app.RecordingTableTab.Title = 'Recording Table';

% Create GridLayoutRecTable
app.GridLayoutRT = uigridlayout(app.RecordingTableTab);
app.GridLayoutRT.ColumnWidth = {'1x', '0.5x', '1.5x', '1x', '1.5x', '0.2x', '1x', '1.5x'};
app.GridLayoutRT.RowHeight = {'1x', '1x', '8x', 2, '1x', '4x'};

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

% Create RecordingTable
app.RecordingTableRT = uitable(app.GridLayoutRT);
app.RecordingTableRT.ColumnName     = app.COLUMNS_NAMES_RT;
app.RecordingTableRT.ColumnEditable = app.COLUMNS_EDITABLE_RT;
app.RecordingTableRT.ColumnFormat   = app.COLUMNS_FORMAT_RT;
app.RecordingTableRT.ColumnSortable = app.COLUMNS_SORTABLE_RT;
app.RecordingTableRT.ColumnWidth    = app.COLUMNS_WIDTH_RT;
app.RecordingTableRT.RowName = {};
app.RecordingTableRT.Layout.Row = 3;
app.RecordingTableRT.Layout.Column = [1 8];
app.RecordingTableRT.CellSelectionCallback = createCallbackFcn(app, @recordingTableSelected, true);



% Create Label_div3_1
app.Label_div3_1 = uilabel(app.GridLayoutRT);
app.Label_div3_1.BackgroundColor = [0 0 0];
app.Label_div3_1.Layout.Row = 4;
app.Label_div3_1.Layout.Column = [1 8];
app.Label_div3_1.Text = 'Label3';

% Create DateDatePickerLabelRT
app.RecordingHistoryLabel = uilabel(app.GridLayoutRT);
app.RecordingHistoryLabel.HorizontalAlignment = 'left';
app.RecordingHistoryLabel.FontSize = 16;
app.RecordingHistoryLabel.FontWeight = 'bold';
app.RecordingHistoryLabel.Layout.Row = 5;
app.RecordingHistoryLabel.Layout.Column = [1 4];
app.RecordingHistoryLabel.Text = 'Recording Status History:' ;

% Create Recording Status History
app.RecordingHistortyTable = uitable(app.GridLayoutRT);
app.RecordingHistortyTable.ColumnName     = app.COLUMNS_RECORDING_STATUS_NAMES;
app.RecordingHistortyTable.ColumnEditable = app.COLUMNS_RECORDING_STATUS_EDITABLE;
app.RecordingHistortyTable.ColumnFormat   = app.COLUMNS_RECORDING_STATUS_FORMAT;
app.RecordingHistortyTable.ColumnSortable = app.COLUMNS_RECORDING_STATUS_SORTABLE;
app.RecordingHistortyTable.ColumnWidth    = app.COLUMNS_RECORDING_STATUS_WIDTH;
app.RecordingHistortyTable.RowName = {};
app.RecordingHistortyTable.Layout.Row = 6;
app.RecordingHistortyTable.Layout.Column = [1 8];


%%%%%%%%%%%%%%%%%%%%%%%%  TAB4  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Create ManageProcessingJobsTab
app.ManageProcessingJobsTab = uitab(app.TabGroup);
app.ManageProcessingJobsTab.Title = 'Manage Processing Jobs';

% Create GridLayoutJobs
app.GridLayoutJobs = uigridlayout(app.ManageProcessingJobsTab);
app.GridLayoutJobs.ColumnWidth = {'1x', '0.5x', '1.5x', '1x', '1.5x', '0.2x', '1x', '1.5x'};
app.GridLayoutJobs.RowHeight = {'1x', '1x', '6x', '1x', 2, '1x', '1x', '1x', '1x', '1x'};

% Create FilterprocessingjobLabel
app.FilterprocessingjobLabel = uilabel(app.GridLayoutJobs);
app.FilterprocessingjobLabel.FontSize = 16;
app.FilterprocessingjobLabel.FontWeight = 'bold';
app.FilterprocessingjobLabel.Layout.Row = 1;
app.FilterprocessingjobLabel.Layout.Column = [1 2];
app.FilterprocessingjobLabel.Text = '1. Filter processing job';


% Create refreshFilterTableButton
app.refreshFilterTableButton = uibutton(app.GridLayoutJobs, 'push');
app.refreshFilterTableButton.Text = 'Refresh filter';
app.refreshFilterTableButton.Icon = 'reload.png';
app.refreshFilterTableButton.Layout.Row = 2;
app.refreshFilterTableButton.Layout.Column = 1;
app.refreshFilterTableButton.ButtonPushedFcn = createCallbackFcn(app, @filterTable, true);

% Create UserDropDownLabel
app.UserDropDownLabel = uilabel(app.GridLayoutJobs);
app.UserDropDownLabel.HorizontalAlignment = 'right';
app.UserDropDownLabel.Layout.Row = 2;
app.UserDropDownLabel.Layout.Column = 2;
app.UserDropDownLabel.Text = 'User';

% Create UserDropDown
app.UserDropDown = uidropdown(app.GridLayoutJobs);
app.UserDropDown.Layout.Row = 2;
app.UserDropDown.Layout.Column = 3;
app.UserDropDown.Items = {};
app.UserDropDown.ValueChangedFcn = createCallbackFcn(app, @filterTable, true);

% Create SubjectDropDown_2Label
app.SubjectDropDown_2Label = uilabel(app.GridLayoutJobs);
app.SubjectDropDown_2Label.HorizontalAlignment = 'right';
app.SubjectDropDown_2Label.Layout.Row = 2;
app.SubjectDropDown_2Label.Layout.Column = 4;
app.SubjectDropDown_2Label.Text = 'Subject';
app.SubjectDropDown_2Label.Enable = 'off';

% Create SubjectDropDown_2
app.SubjectDropDown_2 = uidropdown(app.GridLayoutJobs);
app.SubjectDropDown_2.Layout.Row = 2;
app.SubjectDropDown_2.Layout.Column = 5;
app.SubjectDropDown_2.Items = {};
app.SubjectDropDown_2.ValueChangedFcn = createCallbackFcn(app, @filterTable, true);

% Create DateDatePickerLabel
app.DateDatePickerLabel = uilabel(app.GridLayoutJobs);
app.DateDatePickerLabel.HorizontalAlignment = 'right';
app.DateDatePickerLabel.Layout.Row = 2;
app.DateDatePickerLabel.Layout.Column = 7;
app.DateDatePickerLabel.Text = 'Date';

% Create DateDatePicker
app.DateDatePicker = uidatepicker(app.GridLayoutJobs);
app.DateDatePicker.Layout.Row = 2;
app.DateDatePicker.Layout.Column = 8;
app.DateDatePicker.ValueChangedFcn = createCallbackFcn(app, @filterTable, true);

% Create JobTable
app.JobTable = uitable(app.GridLayoutJobs);
app.JobTable.ColumnName     = app.COLUMNS_JOB_NAMES;
app.JobTable.ColumnEditable = app.COLUMNS_JOB_EDITABLE;
app.JobTable.ColumnFormat   = app.COLUMNS_JOB_FORMAT;
app.JobTable.ColumnSortable = app.COLUMNS_JOB_SORTABLE;
app.JobTable.ColumnWidth = app.COLUMNS_JOB_WIDTH;
app.JobTable.RowName = {};
app.JobTable.Layout.Row = 3;
app.JobTable.Layout.Column = [1 8];
app.JobTable.CellSelectionCallback = createCallbackFcn(app, @jobTableSelected, true);


% Create RunJobDiffParamsButton
app.RunJobDiffParamsButton = uibutton(app.GridLayoutJobs, 'push');
app.RunJobDiffParamsButton.BackgroundColor = [1 0.8784 0.6706];
app.RunJobDiffParamsButton.FontSize = 14;
app.RunJobDiffParamsButton.FontWeight = 'bold';
app.RunJobDiffParamsButton.Layout.Row = 4;
app.RunJobDiffParamsButton.Layout.Column = [4 5];
app.RunJobDiffParamsButton.Text = 'New job with different parameters';
app.RunJobDiffParamsButton.Enable = 'on';
app.RunJobDiffParamsButton.ButtonPushedFcn = createCallbackFcn(app, @RunJobDiffParams, true);

% Create RerunJobStartButton
app.RerunJobStartButton = uibutton(app.GridLayoutJobs, 'push');
app.RerunJobStartButton.BackgroundColor = [0.9412 0.9804 0.6745];
app.RerunJobStartButton.FontSize = 14;
app.RerunJobStartButton.FontWeight = 'bold';
app.RerunJobStartButton.Layout.Row = 4;
app.RerunJobStartButton.Layout.Column = [7 8];
app.RerunJobStartButton.Text = 'Rerun job';
app.RerunJobStartButton.Enable = 'off';
app.RerunJobStartButton.ButtonPushedFcn = createCallbackFcn(app, @RerunJob, true);

% Create Label3
app.Label3 = uilabel(app.GridLayoutJobs);
app.Label3.BackgroundColor = [0 0 0];
app.Label3.Layout.Row = 5;
app.Label3.Layout.Column = [1 8];
app.Label3.Text = 'Label3';

% Create JobHistoryLabel
app.JobHistoryLabel = uilabel(app.GridLayoutJobs);
app.JobHistoryLabel.HorizontalAlignment = 'left';
app.JobHistoryLabel.FontSize = 16;
app.JobHistoryLabel.FontWeight = 'bold';
app.JobHistoryLabel.Layout.Row = 6;
app.JobHistoryLabel.Layout.Column = [1 4];
app.JobHistoryLabel.Text = 'Job Status History:' ;

% Create Recording Status History
app.JobHistoryTable = uitable(app.GridLayoutJobs);
app.JobHistoryTable.ColumnName     = app.COLUMNS_JOB_STATUS_NAMES;
app.JobHistoryTable.ColumnEditable = app.COLUMNS_JOB_STATUS_EDITABLE;
app.JobHistoryTable.ColumnFormat   = app.COLUMNS_JOB_STATUS_FORMAT;
app.JobHistoryTable.ColumnSortable = app.COLUMNS_JOB_STATUS_SORTABLE;
app.JobHistoryTable.ColumnWidth    = app.COLUMNS_JOB_STATUS_WIDTH;
app.JobHistoryTable.RowName = {};
app.JobHistoryTable.Layout.Row = [7 10];
app.JobHistoryTable.Layout.Column = [1 6];

% Create OpenResultsLabel
app.JobHistoryLabel = uilabel(app.GridLayoutJobs);
app.JobHistoryLabel.HorizontalAlignment = 'left';
app.JobHistoryLabel.FontSize = 16;
app.JobHistoryLabel.FontWeight = 'bold';
app.JobHistoryLabel.Layout.Row = 7;
app.JobHistoryLabel.Layout.Column = [7 8];
app.JobHistoryLabel.Text = 'Open results:' ;

% Create OpenPhyFileButton
app.OpenPhyFileButton = uibutton(app.GridLayoutJobs, 'push');
%app.OpenPhyFileButton.BackgroundColor = [0.9412 0.9804 0.6745];
app.OpenPhyFileButton.FontSize = 14;
app.OpenPhyFileButton.FontWeight = 'bold';
app.OpenPhyFileButton.Layout.Row = 8;
app.OpenPhyFileButton.Layout.Column = [7 8];
app.OpenPhyFileButton.Text = 'Open results file';
app.OpenPhyFileButton.Enable = 'off';
%app.OpenPhyFileButton.ButtonPushedFcn = createCallbackFcn(app, @OpenPhyFile, true);

% Create OpenOutLogButton
app.OpenExtGUIButton = uibutton(app.GridLayoutJobs, 'push');
%app.OpenOutLogButton.BackgroundColor = [0.9412 0.9804 0.6745];
app.OpenExtGUIButton.FontSize = 14;
app.OpenExtGUIButton.FontWeight = 'bold';
app.OpenExtGUIButton.Layout.Row = 9;
app.OpenExtGUIButton.Layout.Column = 8;
app.OpenExtGUIButton.Text = 'Open Phy';
app.OpenExtGUIButton.Enable = 'on';
app.OpenExtGUIButton.ButtonPushedFcn = createCallbackFcn(app, @OpenExtGUI, true);

% Create OpenErrLogButton
app.OpenExtGUIButton2 = uibutton(app.GridLayoutJobs, 'push');
%app.OpenErrLogButton.BackgroundColor = [0.9412 0.9804 0.6745];
app.OpenExtGUIButton2.FontSize = 14;
app.OpenExtGUIButton2.FontWeight = 'bold';
app.OpenExtGUIButton2.Layout.Row = 10;
app.OpenExtGUIButton2.Layout.Column = 8;
app.OpenExtGUIButton2.Text = 'Open IBL-Atlas';
app.OpenExtGUIButton2.Enable = 'on';
app.OpenExtGUIButton2.ButtonPushedFcn = createCallbackFcn(app, @OpenExtGUI2, true);

% Create OpenOutLogButton
app.OpenOutLogButton = uibutton(app.GridLayoutJobs, 'push');
%app.OpenOutLogButton.BackgroundColor = [0.9412 0.9804 0.6745];
app.OpenOutLogButton.FontSize = 14;
app.OpenOutLogButton.FontWeight = 'bold';
app.OpenOutLogButton.Layout.Row = 9;
app.OpenOutLogButton.Layout.Column = 7;
app.OpenOutLogButton.Text = 'Open Output log file';
app.OpenOutLogButton.Enable = 'on';
app.OpenOutLogButton.ButtonPushedFcn = createCallbackFcn(app, @OpenLog, true);

% Create OpenErrLogButton
app.OpenErrLogButton = uibutton(app.GridLayoutJobs, 'push');
%app.OpenErrLogButton.BackgroundColor = [0.9412 0.9804 0.6745];
app.OpenErrLogButton.FontSize = 14;
app.OpenErrLogButton.FontWeight = 'bold';
app.OpenErrLogButton.Layout.Row = 10;
app.OpenErrLogButton.Layout.Column = 7;
app.OpenErrLogButton.Text = 'Open Error log file';
app.OpenErrLogButton.Enable = 'on';
app.OpenErrLogButton.ButtonPushedFcn = createCallbackFcn(app, @OpenLog, true);



%%%%%%%%%%%%%%%%%%%%%%%%  TAB5  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create CreateParamsTab
app.CreateParamsTab = uitab(app.TabGroup);
app.CreateParamsTab.Title = 'Create Parameters';

% Create GridLayout3
app.GridLayoutCP = uigridlayout(app.CreateParamsTab);
app.GridLayoutCP.ColumnWidth = {'3x', '4x', '5x', '1x', '1x', '2x', '3x', '3x'};
app.GridLayoutCP.RowHeight = {'1x', '1x', 1, '1x', '1x', '1x', 2, '1x', '1x', '1x', 2, '1x', '1x', '1x', '1x', '1x'};

% Create CreateParamsTextAreaTitle
app.CreateParamsTextAreaTitle = uilabel(app.GridLayoutCP);
app.CreateParamsTextAreaTitle.FontSize = 14;
app.CreateParamsTextAreaTitle.FontWeight = 'bold';
app.CreateParamsTextAreaTitle.Layout.Row = 1;
app.CreateParamsTextAreaTitle.Layout.Column = [7 8];
app.CreateParamsTextAreaTitle.Text = 'Json viewer:';

% Create ParamsTextArea
app.CreateParamsTextArea = uitextarea(app.GridLayoutCP);
app.CreateParamsTextArea.Layout.Row = [2 16];
app.CreateParamsTextArea.Layout.Column = [7 8];

% Create CreatePreParamSetLabel
app.ModalityUserLabel = uilabel(app.GridLayoutCP);
app.ModalityUserLabel.FontSize = 16;
app.ModalityUserLabel.FontWeight = 'bold';
app.ModalityUserLabel.Layout.Row = 1;
app.ModalityUserLabel.Layout.Column = [1 2];
app.ModalityUserLabel.Text = '0. Select Modality & User: ';

% Create Modality selection 
app.ParamModalityLabel = uilabel(app.GridLayoutCP);
app.ParamModalityLabel.HorizontalAlignment = 'right';
app.ParamModalityLabel.FontWeight = 'bold';
app.ParamModalityLabel.Layout.Row = 2;
app.ParamModalityLabel.Layout.Column = [1];
app.ParamModalityLabel.Text = 'Recording Modality:';

% Create PreprocessingParamsDropDown
app.ParamModalityDrop = uidropdown(app.GridLayoutCP);
app.ParamModalityDrop.Layout.Row = 2;
app.ParamModalityDrop.Layout.Column = 2;
app.ParamModalityDrop.ValueChangedFcn = createCallbackFcn(app, @fillPreParamsSets, true);


% Create UserPreparamListLabel
app.UserPreparamListLabel = uilabel(app.GridLayoutCP);
app.UserPreparamListLabel.HorizontalAlignment = 'right';
app.UserPreparamListLabel.FontWeight = 'bold';
app.UserPreparamListLabel.Layout.Row = 2;
app.UserPreparamListLabel.Layout.Column = 3;
app.UserPreparamListLabel.Text = 'User: ';

% Create PreparamListNewNameEdit
app.UserPreparamListDrop = uidropdown(app.GridLayoutCP);
app.UserPreparamListDrop.Layout.Row = 2;
app.UserPreparamListDrop.Layout.Column = [4 6];

% Create Label
app.SepLabel0 = uilabel(app.GridLayoutCP);
app.SepLabel0.BackgroundColor = [0 0 0];
app.SepLabel0.Layout.Row = 3;
app.SepLabel0.Layout.Column = [1 5];

% Create CreatePreParamSetLabel
app.CreateParamSetLabel = uilabel(app.GridLayoutCP);
app.CreateParamSetLabel.FontSize = 16;
app.CreateParamSetLabel.FontWeight = 'bold';
app.CreateParamSetLabel.Layout.Row = 4;
app.CreateParamSetLabel.Layout.Column = [1 2];
app.CreateParamSetLabel.Text = '1a. Register Processing Param Set';

app.NewParamMethodCheckBox = uicheckbox(app.GridLayoutCP);
app.NewParamMethodCheckBox.Text = 'Define new proc. param method ?';
app.NewParamMethodCheckBox.Layout.Row = 4;
app.NewParamMethodCheckBox.Layout.Column = [3];
app.NewParamMethodCheckBox.Value = false;
app.NewParamMethodCheckBox.ValueChangedFcn = createCallbackFcn(app, @checkBoxParamMethod, true);

% Create PreprocessingParamsDropDown
app.CreateParamSetMethodsDropLabel = uilabel(app.GridLayoutCP);
app.CreateParamSetMethodsDropLabel.HorizontalAlignment = 'right';
app.CreateParamSetMethodsDropLabel.Layout.Row = 5;
app.CreateParamSetMethodsDropLabel.FontWeight = 'bold';
app.CreateParamSetMethodsDropLabel.Layout.Column = 1;
app.CreateParamSetMethodsDropLabel.Text = 'Proc. Params Methods: ';

app.CreateParamSetMethodsDrop = uidropdown(app.GridLayoutCP);
app.CreateParamSetMethodsDrop.Layout.Row = 5;
app.CreateParamSetMethodsDrop.Layout.Column = 2;

app.NewParamMethodLabel = uilabel(app.GridLayoutCP);
app.NewParamMethodLabel.HorizontalAlignment = 'right';
app.NewParamMethodLabel.Enable = 'off';
app.NewParamMethodLabel.FontWeight = 'bold';
app.NewParamMethodLabel.Layout.Row = 6;
app.NewParamMethodLabel.Layout.Column = 1;
app.NewParamMethodLabel.Text = 'New Proc. Param Method: ';

% Create PreparamListNewNameEdit
app.NewParamMethodEdit = uieditfield(app.GridLayoutCP, 'text');
app.NewParamMethodEdit.Enable =  'off';
app.NewParamMethodEdit.Layout.Row = 6;
app.NewParamMethodEdit.Layout.Column = [2];

app.NewParamSetDescLabel = uilabel(app.GridLayoutCP);
app.NewParamSetDescLabel.HorizontalAlignment = 'right';
app.NewParamSetDescLabel.Layout.Row = 5;
app.NewParamSetDescLabel.FontWeight = 'bold';
app.NewParamSetDescLabel.Layout.Column = 3;
app.NewParamSetDescLabel.Text = 'Proc.-Param Set description: ';

% Create PreparamListNewNameEdit
app.NewParamSetDescEdit = uieditfield(app.GridLayoutCP, 'text');
app.NewParamSetDescEdit.Layout.Row = 5;
app.NewParamSetDescEdit.Layout.Column = [4 6];

% Create PreparamListNewNameEdit
app.UploadParamSetFile = uibutton(app.GridLayoutCP);
app.UploadParamSetFile.Text = 'Upload Proc.-Param Set json file';
app.UploadParamSetFile.Layout.Row = 6;
app.UploadParamSetFile.Layout.Column = 3;
app.UploadParamSetFile.BackgroundColor = app.ErrorColor;
app.UploadParamSetFile.ButtonPushedFcn = createCallbackFcn(app, @UploadParamJsonFile, true);
%app.UploadPreParamSetFile.ButtonPushedFcn = createCallbackFcn(app, @AddPreParamStepNewList, true);

app.RegisterParamSetButton = uibutton(app.GridLayoutCP);
app.RegisterParamSetButton.Text = 'Register Proc. Param Set';
app.RegisterParamSetButton.BackgroundColor = app.GreenBColor;
app.RegisterParamSetButton.Layout.Row = 6;
app.RegisterParamSetButton.Layout.Column = [4 6];
app.RegisterParamSetButton.ButtonPushedFcn = createCallbackFcn(app, @writeParametersDB, true);
%app.RegisterPreParamSetButton.ButtonPushedFcn = createCallbackFcn(app, @AddPreParamStepNewList, true);

% Create Label
app.SepLabel1 = uilabel(app.GridLayoutCP);
app.SepLabel1.BackgroundColor = [0 0 0];
app.SepLabel1.Layout.Row = 7;
app.SepLabel1.Layout.Column = [1 5];


% Create CreatePreParamSetLabel
app.CreatePreParamSetLabel = uilabel(app.GridLayoutCP);
app.CreatePreParamSetLabel.FontSize = 16;
app.CreatePreParamSetLabel.FontWeight = 'bold';
app.CreatePreParamSetLabel.Layout.Row = 8;
app.CreatePreParamSetLabel.Layout.Column = [1 2];
app.CreatePreParamSetLabel.Text = '1b. Register New Preprocessing-Params Set';

app.NewPreParamMethodCheckBox = uicheckbox(app.GridLayoutCP);
app.NewPreParamMethodCheckBox.Text = 'Define new preproc.-param method ?';
app.NewPreParamMethodCheckBox.Layout.Row = 8;
app.NewPreParamMethodCheckBox.Layout.Column = [3];
app.NewPreParamMethodCheckBox.Value = false;
app.NewPreParamMethodCheckBox.ValueChangedFcn = createCallbackFcn(app, @checkBoxPreParamMethod, true);




% Create PreprocessingParamsDropDown
app.CreatePreParamSetMethodsDropLabel = uilabel(app.GridLayoutCP);
app.CreatePreParamSetMethodsDropLabel.HorizontalAlignment = 'right';
app.CreatePreParamSetMethodsDropLabel.Layout.Row = 9;
app.CreatePreParamSetMethodsDropLabel.FontWeight = 'bold';
app.CreatePreParamSetMethodsDropLabel.Layout.Column = 1;
app.CreatePreParamSetMethodsDropLabel.Text = 'Preproc.-Param Methods: ';

app.CreatePreParamSetMethodsDrop = uidropdown(app.GridLayoutCP);
app.CreatePreParamSetMethodsDrop.Layout.Row = 9;
app.CreatePreParamSetMethodsDrop.Layout.Column = 2;

app.NewPreParamMethodLabel = uilabel(app.GridLayoutCP);
app.NewPreParamMethodLabel.HorizontalAlignment = 'right';
app.NewPreParamMethodLabel.Enable = 'off';
app.NewPreParamMethodLabel.FontWeight = 'bold';
app.NewPreParamMethodLabel.Layout.Row = 10;
app.NewPreParamMethodLabel.Layout.Column = 1;
app.NewPreParamMethodLabel.Text = 'New Preproc.-Param Method: ';

% Create PreparamListNewNameEdit
app.NewPreParamMethodEdit = uieditfield(app.GridLayoutCP, 'text');
app.NewPreParamMethodEdit.Enable =  'off';
app.NewPreParamMethodEdit.Layout.Row = 10;
app.NewPreParamMethodEdit.Layout.Column = [2];

app.NewPreParamSetDescLabel = uilabel(app.GridLayoutCP);
app.NewPreParamSetDescLabel.HorizontalAlignment = 'right';
app.NewPreParamSetDescLabel.Layout.Row = 9;
app.NewPreParamSetDescLabel.FontWeight = 'bold';
app.NewPreParamSetDescLabel.Layout.Column = 3;
app.NewPreParamSetDescLabel.Text = 'Preproc.-Param Set description: ';

% Create PreparamListNewNameEdit
app.NewPreParamSetDescEdit = uieditfield(app.GridLayoutCP, 'text');
app.NewPreParamSetDescEdit.Layout.Row = 9;
app.NewPreParamSetDescEdit.Layout.Column = [4 6];

% Create PreparamListNewNameEdit
app.UploadPreParamSetFile = uibutton(app.GridLayoutCP);
app.UploadPreParamSetFile.Text = 'Upload Preproc.-Param Set json file';
app.UploadPreParamSetFile.Layout.Row = 10;
app.UploadPreParamSetFile.Layout.Column = 3;
app.UploadPreParamSetFile.BackgroundColor = app.ErrorColor;
app.UploadPreParamSetFile.ButtonPushedFcn = createCallbackFcn(app, @UploadParamJsonFile, true);

app.RegisterPreParamSetButton = uibutton(app.GridLayoutCP);
app.RegisterPreParamSetButton.Text = 'Register Preproc. Param Set';
app.RegisterPreParamSetButton.BackgroundColor = app.GreenBColor;
app.RegisterPreParamSetButton.Layout.Row = 10;
app.RegisterPreParamSetButton.Layout.Column = [4 6];
app.RegisterPreParamSetButton.ButtonPushedFcn = createCallbackFcn(app, @writeParametersDB, true);

% Create Label
app.SepLabel2 = uilabel(app.GridLayoutCP);
app.SepLabel2.BackgroundColor = [0 0 0];
app.SepLabel2.Layout.Row = 11;
app.SepLabel2.Layout.Column = [1 5];



% Create Select Pre-Params List
app.CreatePreParamListLabel = uilabel(app.GridLayoutCP);
app.CreatePreParamListLabel.FontSize = 16;
app.CreatePreParamListLabel.FontWeight = 'bold';
app.CreatePreParamListLabel.Layout.Row = 12;
app.CreatePreParamListLabel.Layout.Column = [1 6];
app.CreatePreParamListLabel.Text = '1c. Create a New Preprocessing-Params List (Multiple Preprocessing steps)';


% Create PreparamListNewNameLabel
app.PreparamListNewNameLabel = uilabel(app.GridLayoutCP);
app.PreparamListNewNameLabel.HorizontalAlignment = 'right';
app.PreparamListNewNameLabel.FontWeight = 'bold';
app.PreparamListNewNameLabel.Layout.Row = 13;
app.PreparamListNewNameLabel.Layout.Column = 1;
app.PreparamListNewNameLabel.Text = 'Pre-Params List Name: ';

% Create PreparamListNewNameEdit
app.PreparamListNewNameEdit = uieditfield(app.GridLayoutCP, 'text');
app.PreparamListNewNameEdit.Layout.Row = 13;
app.PreparamListNewNameEdit.Layout.Column = 2;


% Create PreparamListNewDescLabel
app.PreparamListNewDescLabel = uilabel(app.GridLayoutCP);
app.PreparamListNewDescLabel.HorizontalAlignment = 'right';
app.PreparamListNewDescLabel.FontWeight = 'bold';
app.PreparamListNewDescLabel.Layout.Row = 13;
app.PreparamListNewDescLabel.Layout.Column = 3;
app.PreparamListNewDescLabel.Text = 'Pre-Params List Description: ';

% Create PreparamListNewNameEdit
app.PreparamListNewDescEdit = uieditfield(app.GridLayoutCP, 'text');
app.PreparamListNewDescEdit.Layout.Row = 13;
app.PreparamListNewDescEdit.Layout.Column = [4 6];

% Create PreprocessingParamsDropDown
app.PreParamsStepsDropLabel = uilabel(app.GridLayoutCP);
app.PreParamsStepsDropLabel.HorizontalAlignment = 'right';
app.PreParamsStepsDropLabel.Layout.Row = 14;
app.PreParamsStepsDropLabel.FontWeight = 'bold';
app.PreParamsStepsDropLabel.Layout.Column = 1;
app.PreParamsStepsDropLabel.Text = 'Pre-Params Steps: ';

% Create PreprocessingParamsDropDown
app.PreParamsStepsDrop = uidropdown(app.GridLayoutCP);
app.PreParamsStepsDrop.Layout.Row = 14;
app.PreParamsStepsDrop.Layout.Column = 2;
app.PreParamsStepsDrop.ValueChangedFcn = createCallbackFcn(app, @CreatePreparamStepSelected, true);

% Create AddPreParamStepButton
app.AddPreParamStepButton = uibutton(app.GridLayoutCP);
app.AddPreParamStepButton.Text = 'Add preparam step';
app.AddPreParamStepButton.Layout.Row = 15;
app.AddPreParamStepButton.Layout.Column = 2;
app.AddPreParamStepButton.ButtonPushedFcn = createCallbackFcn(app, @AddPreParamStepNewList, true);

% Create ListBox Fragments
app.NewPreParamsListStepsList = uilistbox(app.GridLayoutCP);
app.NewPreParamsListStepsList.Layout.Row = [14 16];
app.NewPreParamsListStepsList.Layout.Column = 3;
app.NewPreParamsListStepsList.Items = {};
%app.NewPreParamsListStepsList.ValueChangedFcn = createCallbackFcn(app, @PreparamStepSelected, true);

% Create MoveStepUp
app.MoveStepUp = uibutton(app.GridLayoutCP);
app.MoveStepUp.Text = '^';
app.MoveStepUp.Layout.Row = 14;
app.MoveStepUp.Layout.Column = 4;
app.MoveStepUp.ButtonPushedFcn = createCallbackFcn(app, @MoveStepOrderClicked, true);

% Create MoveStepDown
app.MoveStepDown = uibutton(app.GridLayoutCP);
app.MoveStepDown.Text = 'v';
app.MoveStepDown.Layout.Row = 15;
app.MoveStepDown.Layout.Column = 4;
app.MoveStepDown.ButtonPushedFcn = createCallbackFcn(app, @MoveStepOrderClicked, true);

% Create DeleteStep
app.DeleteStep = uibutton(app.GridLayoutCP);
app.DeleteStep.Text = 'X';
app.DeleteStep.Layout.Row = 14;
app.DeleteStep.Layout.Column = 5;
app.DeleteStep.ButtonPushedFcn = createCallbackFcn(app, @DeleteStepClicked, true);

% Create AddPreParamStepButton
app.RegisterPreParamListButton = uibutton(app.GridLayoutCP);
app.RegisterPreParamListButton.BackgroundColor = app.GreenBColor;
app.RegisterPreParamListButton.Text = 'Register pre param list';
app.RegisterPreParamListButton.Layout.Row = 16;
app.RegisterPreParamListButton.Layout.Column = [4 6];
app.RegisterPreParamListButton.ButtonPushedFcn = createCallbackFcn(app, @RegisterPreParamList, true);


%%%%%%%%%%%%%%%%%%%%%%%%  TAB6  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Create SystemSetUpTab
app.SystemSetUpTab = uitab(app.TabGroup);
app.SystemSetUpTab.Title = 'System Configuration';

% Create GridLayout
app.GridLayout = uigridlayout(app.SystemSetUpTab);
app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '0.2x'};
app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};


% Create ConfigurationOptionsLabel
app.ConfigurationOptionsLabel = uilabel(app.GridLayout);
app.ConfigurationOptionsLabel.FontSize = 16;
app.ConfigurationOptionsLabel.FontWeight = 'bold';
app.ConfigurationOptionsLabel.Layout.Row = 1;
app.ConfigurationOptionsLabel.Layout.Column = [1 3];
app.ConfigurationOptionsLabel.Text = '1. Configuration Options';

% Create StartConfigurationButton
app.StartConfigurationButton = uibutton(app.GridLayout, 'push');
app.StartConfigurationButton.BackgroundColor = [0.8118 0.9176 0.9804];
app.StartConfigurationButton.FontSize = 14;
app.StartConfigurationButton.FontWeight = 'bold';
app.StartConfigurationButton.Layout.Row = 2;
app.StartConfigurationButton.Layout.Column = [2 5];
app.StartConfigurationButton.Text = 'Start Configuration';
app.StartConfigurationButton.ButtonPushedFcn = createCallbackFcn(app, @startConfiguration, true);


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

% Create SystemLabel
app.SystemLabel = uilabel(app.GridLayout);
app.SystemLabel.Layout.Row = 3;
app.SystemLabel.Layout.Column = 5;
app.SystemLabel.Text = '';


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
app.AssociatedBehaviorRigDropDown.Layout.Column = [2];
app.AssociatedBehaviorRigDropDown.Items = {};

% Create AddAssociatedRigButton
app.AddAssociatedRigButton = uibutton(app.GridLayout, 'push');
app.AddAssociatedRigButton.Enable = 'off';
app.AddAssociatedRigButton.FontSize = 12;
app.AddAssociatedRigButton.FontWeight = 'bold';
app.AddAssociatedRigButton.Layout.Row = 5;
app.AddAssociatedRigButton.Layout.Column = [2];
app.AddAssociatedRigButton.Text = 'Add Rig to System';
app.AddAssociatedRigButton.ButtonPushedFcn = createCallbackFcn(app, @addRig2System, true);

% Create AssociatedBehaviorRigListBox
app.AssociatedBehaviorRigListBox = uilistbox(app.GridLayout);
app.AssociatedBehaviorRigListBox.Enable = 'off';
app.AssociatedBehaviorRigListBox.Layout.Row = [4 5];
app.AssociatedBehaviorRigListBox.Layout.Column = [3 4];
app.AssociatedBehaviorRigListBox.Items = {};

% Create AssociatedBehaviorRigListBox
app.AssociatedBehaviorRigLabel = uilabel(app.GridLayout);
app.AssociatedBehaviorRigLabel.Layout.Row = 4;
app.AssociatedBehaviorRigLabel.Layout.Column = 5;
app.AssociatedBehaviorRigLabel.Text = '';

% Create AddAssociatedRigButton
app.DeleteAssociatedRigButton = uibutton(app.GridLayout, 'push');
app.DeleteAssociatedRigButton.Enable = 'off';
app.DeleteAssociatedRigButton.FontSize = 12;
app.DeleteAssociatedRigButton.FontWeight = 'bold';
app.DeleteAssociatedRigButton.Layout.Row = 5;
app.DeleteAssociatedRigButton.Layout.Column = [5];
app.DeleteAssociatedRigButton.Text = 'Drop Rig from System';
app.DeleteAssociatedRigButton.ButtonPushedFcn = createCallbackFcn(app, @dropRig2System, true);



% Create RecordingModalityDropDownLabel
app.RecordingModalityDropDownLabel = uilabel(app.GridLayout);
app.RecordingModalityDropDownLabel.HorizontalAlignment = 'right';
app.RecordingModalityDropDownLabel.FontSize = 14;
app.RecordingModalityDropDownLabel.Enable = 'off';
app.RecordingModalityDropDownLabel.Layout.Row = 6;
app.RecordingModalityDropDownLabel.Layout.Column = 1;
app.RecordingModalityDropDownLabel.Text = 'Recording Modality';

% Create RecordingModalityDropDown
app.RecordingModalityDropDown = uidropdown(app.GridLayout);
app.RecordingModalityDropDown.Enable = 'off';
app.RecordingModalityDropDown.Layout.Row = 6;
app.RecordingModalityDropDown.Layout.Column = [2 4];
app.RecordingModalityDropDown.Items = {};

% Create RecordingModalityLabel
app.RecordingModalityLabel = uilabel(app.GridLayout);
app.RecordingModalityLabel.Layout.Row = 6;
app.RecordingModalityLabel.Layout.Column = 5;
app.RecordingModalityLabel.Text = '';

% Create RecordingRootDirectoryEditLabel
app.RecordingRootDirectoryEditLabel = uilabel(app.GridLayout);
app.RecordingRootDirectoryEditLabel.HorizontalAlignment = 'right';
app.RecordingRootDirectoryEditLabel.FontSize = 14;
app.RecordingRootDirectoryEditLabel.Enable = 'off';
app.RecordingRootDirectoryEditLabel.Layout.Row = 7;
app.RecordingRootDirectoryEditLabel.Layout.Column = 1;
app.RecordingRootDirectoryEditLabel.Text = 'Recording Root Folder';

% Create RecordingRootDirectoryEdit
app.RecordingRootDirectoryEdit = uieditfield(app.GridLayout, 'text');
app.RecordingRootDirectoryEdit.Enable = 'off';
app.RecordingRootDirectoryEdit.Layout.Row = 7;
app.RecordingRootDirectoryEdit.Layout.Column = [2 6];

% Create SearchDirectoryButton
app.SearchDirectoryButton = uibutton(app.GridLayout, 'push');
app.SearchDirectoryButton.Icon = 'OneDrive_Folder_Icon.svg.png';
app.SearchDirectoryButton.Layout.Row = 7;
app.SearchDirectoryButton.Layout.Column = 7;
app.SearchDirectoryButton.Text = '';
app.SearchDirectoryButton.Enable = 'off';
app.SearchDirectoryButton.ButtonPushedFcn = createCallbackFcn(app, @selectRecordingRootDirectory, true);


% Create RecordingRootDirectoryLabel
app.RecordingRootDirectoryLabel = uilabel(app.GridLayout);
app.RecordingRootDirectoryLabel.Layout.Row = 8;
app.RecordingRootDirectoryLabel.Layout.Column = [2 6];
app.RecordingRootDirectoryLabel.Text = '';


% Create ConfigureSystemButton
app.ConfigureSystemButton = uibutton(app.GridLayout, 'push');
app.ConfigureSystemButton.BackgroundColor = [0.9176 0.9882 0.851];
app.ConfigureSystemButton.FontSize = 14;
app.ConfigureSystemButton.FontWeight = 'bold';
app.ConfigureSystemButton.Layout.Row = 9;
app.ConfigureSystemButton.Layout.Column = [2 5];
app.ConfigureSystemButton.Text = 'Configure System';
app.ConfigureSystemButton.Enable = 'off';
app.ConfigureSystemButton.ButtonPushedFcn = createCallbackFcn(app, @configureSystem, true);


% Show the figure after all components are created
movegui(app.UIFigure, 'center')
app.UIFigure.Visible = 'on';
end

