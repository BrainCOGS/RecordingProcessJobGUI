function [PreprocessParams, ProcessParams, PreProcessParamList] = getParamsFromMatlab(app)

ephys_params = fetch_table_except(dj.conn, ...
    app.param_table_names.electrophysiology.table_class, 'params');
%Rename vars to "common" param method field
ephys_params = renamevars(ephys_params,...
    app.param_methods_table_names.electrophysiology.method_field,...
    app.param_methods_method_field);

ephys_params.recording_modality = repmat({'electrophysiology'},size(ephys_params,1),1);

imaging_params = fetch_table_except(dj.conn, ...
    app.param_table_names.imaging.table_class, 'params');
imaging_params.recording_modality = repmat({'imaging'},size(imaging_params,1),1);


ephys_preparams = fetch_table_except(dj.conn, ...
    app.preparam_table_names.electrophysiology.table_class, 'params');
%Rename vars to "common" preparam method field
ephys_preparams = renamevars(ephys_preparams,...
    app.preparam_methods_table_names.electrophysiology.method_field,...
    app.preparam_methods_method_field);

ephys_preparams.recording_modality = repmat({'electrophysiology'},size(ephys_preparams,1),1);


ephys_steps = fetchDataDJTable(...
    app.preparam_steps_step_table_names.electrophysiology.table_class(), ...
    [], {'*'}, "table");
ephys_steps = join(ephys_steps,ephys_preparams);

ProcessParams    = [ephys_params; imaging_params];
PreprocessParams    = [ephys_preparams];
PreProcessParamList = [ephys_steps];

end