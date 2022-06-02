classdef RecordingProcessJobGUI < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout4                     matlab.ui.container.GridLayout
        U19RecordingProcessingJobsGUILabel  matlab.ui.control.Label
        Image                           matlab.ui.control.Image
        TabGroup                        matlab.ui.container.TabGroup
        AddRecordingProcessingJobTab    matlab.ui.container.Tab
        SelectRecordingParametersTab    matlab.ui.container.Tab
        RecordingTableTab               matlab.ui.container.Tab
        GridLayout2                     matlab.ui.container.GridLayout
        GridLayoutRT                    matlab.ui.container.GridLayout
        SelectRecordingDirectoryLabel   matlab.ui.control.Label
        RecordingDirectoryLabel         matlab.ui.control.HTML
        RecordingDirectoryDropDownLabel matlab.ui.control.Label
        RecordingDirectoryDropDown      matlab.ui.control.DropDown
        IstherebehaviorSessionCheckBox  matlab.ui.control.CheckBox
        BehaviorSessionDropDownLabel    matlab.ui.control.Label
        BehaviorSessionDropDown         matlab.ui.control.DropDown
        ConfigurationLabel              matlab.ui.control.HTML
        RecordingSubjectDropDown_2Label matlab.ui.control.Label
        RecordingSubjectDropDown_2      matlab.ui.control.DropDown
        Label                           matlab.ui.control.Label
        SelectSessionorLabel            matlab.ui.control.Label
        Label2                          matlab.ui.control.Label
        SelectProcessingParametersLabel  matlab.ui.control.Label
        SamePreParamListRecordingCheckBox matlab.ui.control.CheckBox
        SameParamsRecordingCheckBox     matlab.ui.control.CheckBox
        ParamListLabel                  matlab.ui.control.Label
        PreParamListLabel               matlab.ui.control.Label
        ListBoxFragmentRecording        matlab.ui.control.ListBox
        ListBoxFragmentRecordingPreParams matlab.ui.control.ListBox
        ListBoxFragmentRecording2       matlab.ui.control.ListBox
        ListBoxFragmentRecording2Params matlab.ui.control.ListBox
        PreprocessingParamsStepsList    matlab.ui.control.ListBox
        SelectPreParamsListLabel        matlab.ui.control.Label
        SelectParamsListLabel           matlab.ui.control.Label
        PreprocessingParamsLabel        matlab.ui.control.Label
        PreprocessingParamsDropDown     matlab.ui.control.DropDown
        ProcessingParamsDropDownLabel   matlab.ui.control.Label
        ProcessingParamsDropDown        matlab.ui.control.DropDown
        CreateProcessingJobButton       matlab.ui.control.Button
        RegisterPreparamsFragment       matlab.ui.control.Button
        RegisterParamsFragment          matlab.ui.control.Button
        ParamsTextArea                  matlab.ui.control.TextArea
        RecordingDateDatePickerLabel    matlab.ui.control.Label
        RecordingDateDatePicker         matlab.ui.control.DatePicker
        RecordingUserDropDownLabel      matlab.ui.control.Label
        RecordingUserDropDown           matlab.ui.control.DropDown
        ManageProcessingJobsTab         matlab.ui.container.Tab
        GridLayout3                     matlab.ui.container.GridLayout
        FilterRecordingLabel            matlab.ui.control.Label
        FilterprocessingjobLabel        matlab.ui.control.Label
        refreshFilterTableButton        matlab.ui.control.Button
        refreshFilterTableButtonRT      matlab.ui.control.Button
        UserDropDownLabel               matlab.ui.control.Label
        UserDropDownRTLabel             matlab.ui.control.Label
        UserDropDown                    matlab.ui.control.DropDown
        UserDropDownRT                  matlab.ui.control.DropDown
        SubjectDropDown_2Label          matlab.ui.control.Label
        SubjectDropDown_2               matlab.ui.control.DropDown
        SubjectDropDownRTLabel          matlab.ui.control.Label
        SubjectDropDownRT               matlab.ui.control.DropDown
        DateDatePickerLabel             matlab.ui.control.Label
        DateDatePicker                  matlab.ui.control.DatePicker
        DateDatePickerRTLabel           matlab.ui.control.Label
        DateDatePickerRT                matlab.ui.control.DatePicker
        UITable                         matlab.ui.control.Table
        UITableRT                       matlab.ui.control.Table
        EditselectedjobButton           matlab.ui.control.Button
        CreatenewjobforselectedrecordingButton  matlab.ui.control.Button
        SetParamstoeditcreatejobprocessingLabel  matlab.ui.control.Label
        IstherebehaviorSessionCheckBox_2  matlab.ui.control.CheckBox
        DefaultParametersCheckBox       matlab.ui.control.CheckBox
        BehaviorSessionDropDown_2Label  matlab.ui.control.Label
        BehaviorSessionDropDown_2       matlab.ui.control.DropDown
        RecordingSubjectDropDownLabel   matlab.ui.control.Label
        RecordingSubjectDropDown        matlab.ui.control.DropDown
        RecordingDateDatePicker_2Label  matlab.ui.control.Label
        RecordingDateDatePicker_2       matlab.ui.control.DatePicker
        PreprocessingParamsDropDown_2Label  matlab.ui.control.Label
        PreprocessingParamsDropDown_2   matlab.ui.control.DropDown
        ProcessingParamsDropDown_2Label  matlab.ui.control.Label
        ProcessingParamsDropDown_2      matlab.ui.control.DropDown
        TextArea_2                      matlab.ui.control.TextArea
        AcceptEditionCreationButton     matlab.ui.control.Button
        Label3                          matlab.ui.control.Label
        Label4                          matlab.ui.control.Label
        RecordingUserDropDown_2Label    matlab.ui.control.Label
        RecordingUserDropDown_2         matlab.ui.control.DropDown
        SystemSetUpTab                  matlab.ui.container.Tab
        GridLayout                      matlab.ui.container.GridLayout
        SystemNameDropDownLabel         matlab.ui.control.Label
        SystemNameDropDown              matlab.ui.control.DropDown
        RecordingModalityDropDownLabel  matlab.ui.control.Label
        RecordingModalityDropDown       matlab.ui.control.DropDown
        RecordingRootDirectoryEditLabel matlab.ui.control.Label
        RecordingRootDirectoryEdit      matlab.ui.control.EditField
        AssociatedBehaviorRigDropDownLabel  matlab.ui.control.Label
        AssociatedBehaviorRigDropDown   matlab.ui.control.DropDown
        ConfigurationOptionsLabel       matlab.ui.control.Label
        ConfigureSystemButton           matlab.ui.control.Button
        SystemLabel                     matlab.ui.control.Label
        BehaviorRigLabel                matlab.ui.control.Label
        RecordingModalityLabel          matlab.ui.control.Label
        RecordingRootDirectoryLabel     matlab.ui.control.Label
        SearchDirectoryButton           matlab.ui.control.Button
        
        StartConfigurationButton        matlab.ui.control.Button
        BusyLabel                       matlab.ui.control.Label
        ConfigurationNeededLabel        matlab.ui.control.Label
        
        %GUI written data
        DropdownParamsPrevious
        DataTable
        DataRecordingTable
        FilterRecordingJob
        FilterRecordingRT
        
        %Related configuration variables
        Configuration
        RootFolder
        ConfFileFullName
        FileExtensions
        
        % Some schema or fetched tables
        RecordingSchema
        ProcessJobsSchema
        RecordingTable
        RecordingProcessTable
        PreProcessParams
        PreProcessParamList
        ProcessParams
        BehaviorSessions
        
        %Param Selection table (when different for each probe)
        PreParamSelectionTable
        ParamSelectionTable
        
        py_env
        py_enabled
              
    end
    
    properties (Constant = true)
    
        OKColor      = [0.7608        1     0.7922];
        ErrorColor   = [1         0.6588    0.6588];
        ActiveColor  = [0.5078    0.7078         1];
        WhiteColor   = [1             1         1];
        InfoStyle    = "<p style='color: rgb(53, 104, 233); text-align: right; font-size:13px;'>";
        ConfFileName = 'system_conf_job_gui.json';
        
        
        COLUMNS_TABLE      = {             'job_id', 'subject_fullname', 'session_date', 'session_number', 'fragment_number', 'status_processing_id', 'status_processing_definition', 'recording_modality', 'recording_id'};
        COLUMNS_NAMES      = {             'job_id',           'subject',        'date',       'sess_num',     '(probe|fov)',           'status_job',                  'status_desc',           'modality', 'recording_id'};
        COLUMNS_EDITABLE   = false(size(RecordingProcessJobGUI.COLUMNS_TABLE));
        COLUMNS_SORTABLE   = true(size(RecordingProcessJobGUI.COLUMNS_TABLE));
        COLUMNS_FORMAT     = {             'numeric',            'char',         'char',         'numeric',        'numeric',            'numeric',               'char',                    'char',                   'char',              'char',      'numeric'};
        
                
        COLUMNS_TABLE_RT   = {'recording_id', 'subject_fullname', 'session_date', 'session_number', 'status_recording_id',  'status_recording_definition',   'recording_modality', 'recording_directory'};
        COLUMNS_NAMES_RT   = {'recording_id',           'subject',        'date',       'sess_num',     'status_recording',                 'status_desc',            'modality',           'directory'};
        COLUMNS_EDITABLE_RT= false(size(RecordingProcessJobGUI.COLUMNS_TABLE_RT));
        COLUMNS_SORTABLE_RT= true(size(RecordingProcessJobGUI.COLUMNS_TABLE_RT));
        COLUMNS_FORMAT_RT  = {     'numeric',             'char',         'char',        'numeric',              'numeric',            'char',               'char',                    'char',                   'char',              'char'};
        
        
        gui_path = fileparts(mfilename('fullpath'));
        py_env_name    = 'EnvAutoPipeGUI';
        py_scripts_dir = fullfile(fileparts(RecordingProcessJobGUI.gui_path), 'PythonScripts')
        py_read_params = fullfile(RecordingProcessJobGUI.py_scripts_dir, 'read_params.py')
        preparams_mat  = fullfile(RecordingProcessJobGUI.py_scripts_dir, 'preparams.mat')
        preparams_list_mat  = fullfile(RecordingProcessJobGUI.py_scripts_dir, 'preparams_list.mat')
        params_mat          = fullfile(RecordingProcessJobGUI.py_scripts_dir, 'params.mat')
        
    end
        
    % Component initialization
    methods (Access = private)
        
        startupFcn(app, event);
        createComponents(app);
        
        %userChanged(app, event);
        %subjectChanged(app, event);
        
        checkBoxSessionRecording(app, event);
        selectRecordingRootDirectory(app, event);
        ParamsSelected(app, event);
        ParamListSelected(app, event);
        PreparamStepSelected(app, event);
        
        RegisterPreparamFragmentClicked(app, event);
        RegisterParamFragmentClicked(app, event);
        
        SamePreParamCheckClicked(app, event);
        SameParamCheckClicked(app, event);
        
        preparams_final = loadParamsFile(app, param_matfile);
        [PreProcessParams, ProcessParams, PreProcessParamList] = getParamsFromMatlab(app); 
        
        fillRecordingUser(app);
        fillRecordingSubject(app, key);
        fillSubjects(app, key);
        fillSessions(app, key);
        fillTable(app, key);
        filterTable(app, event);
        
        configureSystem(app, event);
        startConfiguration(app,event);
        getPythonEnv(app);
        
        createRecordingButton(app, event);
        createRecording(app, event);
        
        configuration_done = checkConfiguration(app);
        postConfigurationActions(app);
        
        controlEnables(app, structEnables);
        updateBusyLabel(app, status);
        
        
        
        %setStyleBadSessions(app, bad_sessions);
        
    end
    
    % App creation and deletion
    methods (Access = public)
        
        % Construct app
        function app = RecordingProcessJobGUI
            
            
            app.PreParamSelectionTable  = cell2table(cell(0,2), 'VariableNames', {'fragment_number', 'preparam_list_id'});
            app.ParamSelectionTable     = cell2table(cell(0,2), 'VariableNames', {'fragment_number', 'paramset_idx'});
            
            getPythonEnv(app);

            % Create UIFigure and components
            createComponents(app)
            
            % Execute the startup function
            runStartupFcn(app, @startupFcn)
            
            %fillSubjects(app);
            
            % Register the app with App Designer
            registerApp(app, app.UIFigure)
            

            
            if nargout == 0
                clear app
            end
        end
        
        % Code that executes before app deletion
        function delete(app)
            
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end