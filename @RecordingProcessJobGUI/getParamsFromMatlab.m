function [PreProcessParams, ProcessParams, PreProcessParamList] = getParamsFromMatlab(app)

ephys_preparams = fetch_table_except(dj.conn, 'u19_pipeline_ephys_element.`#pre_cluster_param_set`', 'params');
ephys_preparams = renamevars(ephys_preparams,"precluster_method","preprocessing_method");
ephys_preparams.recording_modality = repmat({'electrophysiology'},size(ephys_preparams,1),1);


ephys_params = fetch_table_except(dj.conn, 'u19_pipeline_ephys_element.`#clustering_param_set`', 'params');
ephys_params = renamevars(ephys_params,"clustering_method","processing_method");
ephys_params.recording_modality = repmat({'electrophysiology'},size(ephys_params,1),1);

imaging_params = fetch_table_except(dj.conn, 'u19_pipeline_imaging_element.`#processing_param_set`', 'params');
imaging_params.recording_modality = repmat({'imaging'},size(imaging_params,1),1);

conn = dj.conn;

ephys_steps = struct2table(conn.query(...
    ['select b.* from u19_pipeline_ephys_element.pre_cluster_param_steps  a ' ...
     'inner join u19_pipeline_ephys_element.pre_cluster_param_steps__step b ' ...
     'on a.precluster_param_steps_id = b.precluster_param_steps_id']));
ephys_steps = join(ephys_steps,ephys_preparams);

ProcessParams    = [ephys_params; imaging_params];
PreProcessParams = [ephys_preparams];
PreProcessParamList = [ephys_steps];

end