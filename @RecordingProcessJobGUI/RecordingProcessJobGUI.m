classdef RecordingProcessJobGUI < matlab.apps.AppBase
    
   
    % Properties that correspond to app components
    properties (Access = public)
        
        %Outside any tab
        UIFigure                        matlab.ui.Figure
        GridLayout4                     matlab.ui.container.GridLayout
        U19RecordingProcessingJobsGUILabel  matlab.ui.control.Label
        Image                           matlab.ui.control.Image
        TabGroup                        matlab.ui.container.TabGroup
        BusyLabel                       matlab.ui.control.Label
        ConfigurationLabel              matlab.ui.control.HTML
        ConfigurationNeededLabel        matlab.ui.control.Label

        %Tab1 Create Recording
        AddRecordingProcessingJobTab    matlab.ui.container.Tab
        GridLayout2                     matlab.ui.container.GridLayout
        SelectRecordingDirectoryLabel   matlab.ui.control.Label
        RecordingDirectoryDropDownLabel matlab.ui.control.Label
        RecordingDirectoryDropDown      matlab.ui.control.DropDown
        IstherebehaviorSessionCheckBox  matlab.ui.control.CheckBox
        BehaviorSessionDropDownLabel    matlab.ui.control.Label
        BehaviorSessionDropDown         matlab.ui.control.DropDown
        RecordingUserDropDownLabel      matlab.ui.control.Label
        RecordingUserDropDown           matlab.ui.control.DropDown
        RecordingSubjectDropDownLabel   matlab.ui.control.Label
        RecordingSubjectDropDown        matlab.ui.control.DropDown
        RecordingDateDatePickerLabel    matlab.ui.control.Label
        RecordingDateDatePicker         matlab.ui.control.DatePicker
        Label                           matlab.ui.control.Label
        SelectSessionorLabel            matlab.ui.control.Label
        Label2                          matlab.ui.control.Label
        SelectProcessingParametersLabel matlab.ui.control.Label
        DefaultParametersCheckBox       matlab.ui.control.CheckBox
        DefaultParametersLabel          matlab.ui.control.Label
        DefaultPreParamNameLabel        matlab.ui.control.Label
        DefaultPreParamTable            matlab.ui.control.Table
        Label0                          matlab.ui.control.Label
        DefaultParamNameLabel           matlab.ui.control.Label
        DefaultParamTable               matlab.ui.control.Table
        CreateProcessingJobButton       matlab.ui.control.Button
        
        %Tab 2 Select Parameters
        SelectRecordingParametersTab    matlab.ui.container.Tab
        GridLayout3                     matlab.ui.container.GridLayout
        UserParamsLabel                 matlab.ui.control.Label
        UserParamsDropDown              matlab.ui.control.DropDown
        SelectPreParamsListLabel        matlab.ui.control.Label
        SamePreParamListRecordingCheckBox matlab.ui.control.CheckBox
        ListBoxFragmentRecording        matlab.ui.control.ListBox
        ListBoxFragmentRecordingPreParams matlab.ui.control.ListBox
        PreParamListLabel               matlab.ui.control.Label
        PreprocessingParamsDropDown     matlab.ui.control.DropDown
        ProcessingParamsDropDownLabel   matlab.ui.control.Label
        PreParamsDescriptionLabel       matlab.ui.control.Label
        PreParamsDescriptionLabel2      matlab.ui.control.Label
        UserDatePreParamsLabel          matlab.ui.control.Label
        UserDatePreParamsLabel2         matlab.ui.control.Label
        PreprocessingParamsStepsList    matlab.ui.control.ListBox
        RegisterPreparamsFragment       matlab.ui.control.Button
        Label4                          matlab.ui.control.Label
        ParamsTextAreaTitle             matlab.ui.control.Label
        ParamsTextArea                  matlab.ui.control.TextArea
        SelectParamsListLabel           matlab.ui.control.Label
        ListBoxFragmentRecording2       matlab.ui.control.ListBox
        ListBoxFragmentRecording2Params matlab.ui.control.ListBox
        SameParamsRecordingCheckBox     matlab.ui.control.CheckBox
        ParamListLabel                  matlab.ui.control.Label
        ProcessingParamsDropDown        matlab.ui.control.DropDown
        UserDateParamsLabel             matlab.ui.control.Label
        UserDateParamsLabel2            matlab.ui.control.Label
        RegisterParamsFragment          matlab.ui.control.Button
        CreateProcessingJobButton2      matlab.ui.control.Button

        % Tab 3 Recording tables
        RecordingTableTab               matlab.ui.container.Tab
        GridLayoutRT                    matlab.ui.container.GridLayout
        FilterRecordingLabel            matlab.ui.control.Label
        refreshFilterTableButtonRT      matlab.ui.control.Button
        UserDropDownRTLabel             matlab.ui.control.Label
        UserDropDownRT                  matlab.ui.control.DropDown
        SubjectDropDownRTLabel          matlab.ui.control.Label
        SubjectDropDownRT               matlab.ui.control.DropDown
        DateDatePickerRTLabel           matlab.ui.control.Label
        DateDatePickerRT                matlab.ui.control.DatePicker
        RecordingTableRT                matlab.ui.control.Table
        Label_div3_1                    matlab.ui.control.Label
        RecordingHistoryLabel           matlab.ui.control.Label
        RecordingHistortyTable          matlab.ui.control.Table

        % Tab4 Job tables 
        ManageProcessingJobsTab         matlab.ui.container.Tab
        GridLayoutJobs                  matlab.ui.container.GridLayout
        FilterprocessingjobLabel        matlab.ui.control.Label
        refreshFilterTableButton        matlab.ui.control.Button
        UserDropDownLabel               matlab.ui.control.Label
        UserDropDown                    matlab.ui.control.DropDown
        SubjectDropDown_2Label          matlab.ui.control.Label
        SubjectDropDown_2               matlab.ui.control.DropDown
        DateDatePickerLabel             matlab.ui.control.Label
        DateDatePicker                  matlab.ui.control.DatePicker
        JobTable                        matlab.ui.control.Table
        RunJobDiffParamsButton          matlab.ui.control.Button
        RerunJobStartButton             matlab.ui.control.Button
        Label3                          matlab.ui.control.Label
        JobHistoryLabel                 matlab.ui.control.Label
        JobHistoryTable                 matlab.ui.control.Table
        OpenResultsLabel                matlab.ui.control.Label
        OpenPhyFileButton               matlab.ui.control.Button
        OpenOutLogButton                matlab.ui.control.Button
        OpenErrLogButton                matlab.ui.control.Button

            
        %Tab5 Create Params
        CreateParamsTab                 matlab.ui.container.Tab
        GridLayoutCP                    matlab.ui.container.GridLayout
        CreateParamsTextAreaTitle       matlab.ui.control.Label
        CreateParamsTextArea            matlab.ui.control.TextArea
        ModalityUserLabel               matlab.ui.control.Label
        ParamModalityLabel              matlab.ui.control.Label
        ParamModalityDrop               matlab.ui.control.DropDown
        UserPreparamListLabel           matlab.ui.control.Label
        UserPreparamListDrop            matlab.ui.control.DropDown
        SepLabel0                       matlab.ui.control.Label
        CreateParamSetLabel             matlab.ui.control.Label
        NewParamMethodCheckBox          matlab.ui.control.CheckBox
        CreateParamSetMethodsDropLabel  matlab.ui.control.Label
        CreateParamSetMethodsDrop       matlab.ui.control.DropDown
        NewParamMethodLabel             matlab.ui.control.Label
        NewParamMethodEdit              matlab.ui.control.EditField
        NewParamSetDescLabel            matlab.ui.control.Label
        NewParamSetDescEdit             matlab.ui.control.EditField
        UploadParamSetFile              matlab.ui.control.Button
        RegisterParamSetButton          matlab.ui.control.Button 
        SepLabel1                       matlab.ui.control.Label
        CreatePreParamSetLabel          matlab.ui.control.Label
        NewPreParamMethodCheckBox       matlab.ui.control.CheckBox
        CreatePreParamSetMethodsDropLabel matlab.ui.control.Label
        CreatePreParamSetMethodsDrop    matlab.ui.control.DropDown
        NewPreParamMethodLabel          matlab.ui.control.Label
        NewPreParamMethodEdit           matlab.ui.control.EditField 
        NewPreParamSetDescLabel         matlab.ui.control.Label
        NewPreParamSetDescEdit          matlab.ui.control.EditField
        UploadPreParamSetFile           matlab.ui.control.Button
        RegisterPreParamSetButton       matlab.ui.control.Button
        SepLabel2                       matlab.ui.control.Label
        CreatePreParamListLabel         matlab.ui.control.Label
        PreparamListNewNameLabel        matlab.ui.control.Label
        PreparamListNewNameEdit         matlab.ui.control.EditField
        PreparamListNewDescLabel        matlab.ui.control.Label
        PreparamListNewDescEdit         matlab.ui.control.EditField
        PreParamsStepsDropLabel         matlab.ui.control.Label
        PreParamsStepsDrop              matlab.ui.control.DropDown
        AddPreParamStepButton           matlab.ui.control.Button
        NewPreParamsListStepsList       matlab.ui.control.ListBox
        MoveStepUp                      matlab.ui.control.Button
        MoveStepDown                    matlab.ui.control.Button
        DeleteStep                      matlab.ui.control.Button
        RegisterPreParamListButton      matlab.ui.control.Button

        %Tab6 Configuration
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
        AssociatedBehaviorRigListBox    matlab.ui.control.ListBox
        DeleteAssociatedRigButton       matlab.ui.control.Button
        AddAssociatedRigButton          matlab.ui.control.Button   
        ConfigurationOptionsLabel       matlab.ui.control.Label
        ConfigureSystemButton           matlab.ui.control.Button
        SystemLabel                     matlab.ui.control.Label
        RecordingModalityLabel          matlab.ui.control.Label
        RecordingRootDirectoryLabel     matlab.ui.control.Label
        AssociatedBehaviorRigLabel      matlab.ui.control.Label
        StartConfigurationButton        matlab.ui.control.Button
        SearchDirectoryButton           matlab.ui.control.Button


        %GUI written data
        DataTable
        DataRecordingTable
        FilterRecordingJob
        FilterRecordingRT
        
        %Related configuration variables
        Configuration
        RootFolder
        ConfFileFullName
        FileExtensions
        AllFileExtensions
        
        %Recording Table & JobId table
        RecordingTable
        RecordingProcessTable
        
        %Min and max status
        min_job_status
        max_job_status
        min_rec_status
        max_rec_status
        
        %All params and related tables
        PreProcessParamList
        PreProcessParams
        ProcessParams
        MehodsTable
        PreMethodsTable
        RecordingModalityTable
        
        %Behavior sessions info to correspond to a recording
        BehaviorSessions
        
                
        %Param Selection table (when different for each probe)
        PreParamSelectionTable
        ParamSelectionTable
        
        
        %JsonFile paths to upload params (TAB5 Create Params)
        NewParamJsonFile
        NewPreParamJsonFile
        
        %General (Tab2 select params)
        CreateRecordingOrJob       % true if create whole recording 0 if creating job only
        
        %Last selection on Job or Recording Table
        selectedRecordingRow
        selectedJobRow
        jobid_to_copy
        modality_job_id_copy
        
        %Python environment flags and variables
        py_env
        py_enabled

        %Config table configuration
        param_table_names
        preparam_table_names
        preparam_steps_table_names
        preparam_steps_step_table_names
        param_methods_table_names
        preparam_methods_table_names
        
        %Config, common table names %%%
        params_idx_field
        params_desc_field
        
        preparam_steps_idx_field
        preprocess_steps_name_field
        preprocess_steps_desc_field
        
        preparam_methods_method_field
        preparam_methods_desc_field
        
        param_methods_method_field
        param_methods_desc_field
        %%%%%%%

        %Config, Status history class names
        recording_history_table_class
        job_id_history_table_class
        job_part_parms_table
        
        %Paths
        ProcessedDataPath
        ErrorLogsPath
        OutputLogsPath  
   
    end
    
    properties (Constant = true)
    
        Version      = '1.0';
        OKColor      = [0.7608        1     0.7922];
        ErrorColor   = [1         0.6588    0.6588];
        ActiveColor  = [0.5078    0.7078         1];
        WhiteColor   = [1             1          1];
        NotifyColor  = [0.2078    0.4078    0.9137];
        GreenBColor  = [0.7804    0.9294    0.6784];
        YellowBColor = [0.9294    0.9294       0.5];
        InfoStyle    = "<p style='color: rgb(53, 104, 233); text-align: right; font-size:13px;'>";
        ConfFileName = 'system_conf_job_gui.json';
        
        COLUMNS_JOB_TABLE      = {             'job_id', 'recording_id', 'fragment_number', 'subject_fullname', 'session_date', 'session_number', 'status_processing_id', 'status_processing_definition', 'recording_modality',  'processing_method', 'paramset_desc', 'preprocess_param_steps_name'};
        COLUMNS_JOB_NAMES      = {             'job_id', 'recording_id',     '(probe|fov)',          'subject',        'date',       'sess_num',           'status_job',                  'status_desc',            'modality',   'process_method',   'process_set_desc', 'preprocess_set_desc'};
        COLUMNS_JOB_EDITABLE   = false(size(RecordingProcessJobGUI.COLUMNS_JOB_TABLE));
        COLUMNS_JOB_SORTABLE   = true(size(RecordingProcessJobGUI.COLUMNS_JOB_TABLE));
        COLUMNS_JOB_FORMAT     = {             'numeric',        'char',        'numeric',            'char',          'char',         'numeric',            'numeric',                          'char',                 'char',                       'char', 'char', 'char'};
        COLUMNS_JOB_WIDTH      = {                    60,           100,                90,               180,             90,               90,                   90,                             220,                    130,                          'auto', 'auto', 'auto'};
                
        COLUMNS_TABLE_RT   = {'recording_id', 'subject_fullname', 'session_date', 'session_number', 'status_recording_id',  'status_recording_definition',   'recording_modality', 'recording_directory'};
        COLUMNS_NAMES_RT   = {'recording_id',           'subject',        'date',       'sess_num',          'status_rec',                 'status_desc',            'modality',            'directory'};
        COLUMNS_EDITABLE_RT= false(size(RecordingProcessJobGUI.COLUMNS_TABLE_RT));
        COLUMNS_SORTABLE_RT= true(size(RecordingProcessJobGUI.COLUMNS_TABLE_RT));
        COLUMNS_FORMAT_RT  = {     'numeric',             'char',         'char',        'numeric',              'numeric',                        'char',               'char',                  'char'};
        COLUMNS_WIDTH_RT   = {           100,                200,             85,               90,                    110,                           200,                  130,                  'auto'};
        
        COLUMNS_RECORDING_STATUS_TABLE  = {'recording_log_id', 'recording_id', 'status_recording_id_old', 'status_recording_id_new', 'recording_status_timestamp', 'recording_error_message', 'recording_error_exception'};
        COLUMNS_RECORDING_STATUS_NAMES  = {          'log_id', 'recording_id',             'old_status' ,              'new_status',                  'timestamp',           'error_message',           'error_exception'};
        COLUMNS_RECORDING_STATUS_EDITABLE = true(size(RecordingProcessJobGUI.COLUMNS_RECORDING_STATUS_NAMES));
        COLUMNS_RECORDING_STATUS_SORTABLE = true(size(RecordingProcessJobGUI.COLUMNS_RECORDING_STATUS_NAMES));
        COLUMNS_RECORDING_STATUS_FORMAT = {         'numeric',     'numeric',                 'numeric',                 'numeric',                       'char',                    'char',                      'char'};
        COLUMNS_RECORDING_STATUS_WIDTH  = {                60,           100,                        90,                        95,                          120,                    'auto',                      'auto'};

        COLUMNS_JOB_STATUS_TABLE  = {'log_id', 'job_id',  'status_processing_id_old', 'status_processing_id_new', 'status_timestamp', 'error_message'};
        COLUMNS_JOB_STATUS_NAMES  = {'log_id', 'job_id',                'old_status',               'new_status',        'timestamp', 'error_message'};
        COLUMNS_JOB_STATUS_EDITABLE = true(size(RecordingProcessJobGUI.COLUMNS_RECORDING_STATUS_NAMES));
        COLUMNS_JOB_STATUS_SORTABLE = true(size(RecordingProcessJobGUI.COLUMNS_RECORDING_STATUS_NAMES));
        COLUMNS_JOB_STATUS_FORMAT = {'numeric','numeric',                 'numeric',                   'numeric',             'char',          'char'};
        COLUMNS_JOB_STATUS_WIDTH  = {      60,       65,                         90,                          95,                120,          'auto'};

 
        COLUMNS_DEF_PREPARAMS_TABLE    = {'preprocess_param_steps_name', 'preprocess_param_steps_desc', 'step_number', 'preprocess_method',    'paramset_desc', 'user_params', 'date_params'};
        COLUMNS_DEF_PREPARAMS_NAMES    = {      'Preprocess Param name',       'Preprocess Param desc', 'step number', 'preprocess_method', 'step_description',        'User',        'Date'};
        COLUMNS_DEF_PREPARAMS_FORMAT   = {                       'char',                        'char',        'char',              'char',             'char',        'char',        'char'};
        COLUMNS_DEF_PREPARAMS_SORTABLE = false(size(RecordingProcessJobGUI.COLUMNS_DEF_PREPARAMS_TABLE));
        COLUMNS_DEF_PREPARAMS_EDITABLE = false(size(RecordingProcessJobGUI.COLUMNS_DEF_PREPARAMS_TABLE));
        
        COLUMNS_DEF_PARAMS_TABLE    = {        'paramset_desc', 'processing_method',  'user_params', 'date_params'};
        COLUMNS_DEF_PARAMS_NAMES    = {'Processing Param name',            'Method',         'User',        'Date'};
        COLUMNS_DEF_PARAMS_FORMAT   = {                 'char',               'char',        'char',        'char'};
        COLUMNS_DEF_PARAMS_SORTABLE = false(size(RecordingProcessJobGUI.COLUMNS_DEF_PARAMS_TABLE));
        COLUMNS_DEF_PARAMS_EDITABLE = false(size(RecordingProcessJobGUI.COLUMNS_DEF_PARAMS_TABLE));
        
        %Style vars
        RED_COLOR          = [1 0.8 0.8];
        GREEN_COLOR        = [0.8 1 0.8];
        RED_STYLE          = uistyle('BackgroundColor', RecordingProcessJobGUI.RED_COLOR);
        GREEN_STYLE        = uistyle('BackgroundColor', RecordingProcessJobGUI.GREEN_COLOR);
        
        
        %Python environment variables
        gui_path = fileparts(mfilename('fullpath'));
        py_env_name    = 'EnvAutoPipeGUI';
        %Python scripts
        py_scripts_dir = fullfile(fileparts(RecordingProcessJobGUI.gui_path), 'PythonScripts')
        py_read_params = fullfile(RecordingProcessJobGUI.py_scripts_dir, 'read_params.py')
        py_upload_params = fullfile(RecordingProcessJobGUI.py_scripts_dir, 'upload_params.py')
        %Mat files written by python read_params:
        preparams_mat  = fullfile(RecordingProcessJobGUI.py_scripts_dir, 'preparams.mat')
        preparams_list_mat  = fullfile(RecordingProcessJobGUI.py_scripts_dir, 'preparams_list.mat')
        params_mat          = fullfile(RecordingProcessJobGUI.py_scripts_dir, 'params.mat')
                
    end
        
    % Component initialization
    methods (Access = private)
        
        %Startup and param name configuration 
        startupFcn(app, event);
        createComponents(app);
        configParams(app);
        
        %Parameter fetching related functions (from python or Matlab)
        getPythonEnv(app);
        [PreProcessParams, ProcessParams, PreProcessParamList] = getParamsFromMatlab(app); 
        [default_preparams, default_params] = getDefaultParamsMod(app);
        
        %Tab1 Recording creation
        DefaultParamsCheckBoxToggle(app, event);
        checkBoxSessionRecording(app, event);
        controlEnables(app, structEnables);
        createRecordingButton(app, event);
        createRecording(app, event);
        
        %Tab2 Parameter Selection
        fillUserParams(app, event);
        fillParams2Select(app, event);
        ParamSetSelected(app, event);
        ParamListSelected(app, event);
        PreparamStepSelected(app, event);
        SamePreParamCheckClicked(app, event);
        SameParamCheckClicked(app, event);
        RegisterPreparamFragmentClicked(app, event);
        RegisterParamsFragmentClicked(app, event);
        checkParamSelection(app, event);
        
        %Tab3
        recordingTableSelected(app,event);

        %Tab4
        jobTableSelected(app, event);
        fillJobStatusTable(app, event);
        RerunJob(app, event)
        RunJobDiffParams(app, event);
        CreateNewJob(app, event);
        OpenLog(app, event, type)
        
        %Tab5 Create Params
        checkBoxPreParamMethod(app, event);
        checkBoxParamMethod(app, event);
        UploadParamJsonFile(app, event);
        CreatePreparamStepSelected(app, event);
        DeleteStepClicked(app, event);
        MoveStepOprderClicked(app,event);
        AddPreParamStepNewList(app,event);
        RegisterPreParamList(app, event);
        
        %Tab 6 configuration
        selectRecordingRootDirectory(app, event);
        configureSystem(app, event);
        startConfiguration(app,event);
        configuration_done = checkConfiguration(app);
        postConfigurationActions(app);
        addRig2System(app,event);
        dropRig2System(app,event);
                
        %Utility
        split_param_table = splitDescriptionColumnParams(app, param_table);
        preparams_final = loadParamsFile(app, param_matfile);
        
        
        %Fetch data from DB and fill corresponding GUI objects
        fillRecordingUser(app);
        fillRecordingSubject(app, key);
        fillSubjects(app, key);
        fillSessions(app, key);
        fillUsers(app,key);
        fillJobTable(app, key);
        filterTable(app, event);
        fillPreParamsSets(app, event);
        fillRecordingModality(app);
        fillParams(app);
                
        %Outside any tab (grafical)
        updateBusyLabel(app, status);
                
    end
    
    % App creation and deletion
    methods (Access = public)
        
        % Construct app
        function app = RecordingProcessJobGUI
            
            
            configParams(app);
        
            % Create UIFigure and components
            createComponents(app)
            
            % Execute the startup function
            runStartupFcn(app, @startupFcn);
            
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