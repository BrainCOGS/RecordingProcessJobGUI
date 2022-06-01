


import os
from scipy.io import savemat

this_dir = os.path.dirname(__file__)
os.chdir(this_dir)

import datajoint as dj
dj.conn()

ephys_element =dj.create_virtual_module('u19_pipeline_ephys_element','u19_pipeline_ephys_element')
imaging_element =dj.create_virtual_module('u19_pipeline_imaging_element','u19_pipeline_imaging_element')

modalities             = ['electrophysiology', 'imaging']
params_tables          = [ephys_element.ClusteringParamSet, imaging_element.ProcessingParamSet]
preparams_tables       = [ephys_element.PreClusterParamSet]
preparams_steps_tables = [(ephys_element.PreClusterParamSteps * ephys_element.PreClusterParamSteps.Step * ephys_element.PreClusterParamSet)]

###################################Fetch all params from all modalities
params_dict_list = []
for table in params_tables:
    params_dict_list.append(table.fetch(as_dict=True))


#Append all params in the same dictionary
params_dict_dict = {}
num_params = 0
for idx, param_modality_list in enumerate(params_dict_list):
    for dict in param_modality_list:
        dict['recording_modality'] = modalities[idx]
        dict['param_set_hash'] = str(dict['param_set_hash'])
        if 'clustering_method' in dict:
            dict['processing_method'] = dict.pop('clustering_method')
    
        params_dict_dict['param_'+str(num_params)] = dict
        num_params +=1

#################################################Fetch all preparams from all modalities
preparams_dict_list = []
for table in preparams_tables:
    preparams_dict_list.append(table.fetch(as_dict=True))


#Append all preparams in the same dictionary
preparams_dict_dict = {}
num_preparams = 0
for idx, preparam_modality_list in enumerate(preparams_dict_list):
    for dict in preparam_modality_list:
        dict['recording_modality'] = modalities[idx]
        dict['param_set_hash'] = str(dict['param_set_hash'])
        if 'precluster_method' in dict:
            dict['preprocessing_method'] = dict.pop('precluster_method')
    
        preparams_dict_dict['param_'+str(num_preparams)] = dict
        num_preparams +=1

#################################################Fetch all preparamsStepList from all modalities
preparams_steps = []
for table in preparams_steps_tables:
    preparams_steps.append(table.fetch(as_dict=True))

#Append all preparams in the same dictionary
preparams_steps_dict_dict = {}
num_preparams_steps = 0
for idx, preparam_modality_list in enumerate(preparams_steps):
    for dict in preparam_modality_list:
        dict['param_set_hash'] = str(dict['param_set_hash'])
        dict['recording_modality'] = modalities[idx]
        if 'precluster_param_steps_id' in dict:
            dict['preprocessing_param_steps_id'] = dict.pop('precluster_param_steps_id')
        if 'precluster_method' in dict:
            dict['preprocessing_method'] = dict.pop('precluster_method')
        dict['steps_description'] = 'Preparam_list'+str(dict['preprocessing_param_steps_id'])
    
        preparams_steps_dict_dict['param_'+str(num_preparams_steps)] = dict
        num_preparams_steps +=1

print(preparams_steps_dict_dict)

dj.conn().close()


savemat('params.mat', params_dict_dict)
savemat('preparams.mat', preparams_dict_dict)
savemat('preparams_list.mat', preparams_steps_dict_dict)