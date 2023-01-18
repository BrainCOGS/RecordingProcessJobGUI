
import sys
import json
import os


this_dir = os.path.dirname(__file__)
os.chdir(this_dir)
import datajoint as dj
from element_interface.utils import dict_to_uuid


dj.conn()

field_dictionary = {
    'electrophysiology': { 
        'preprocessing': {
            'module': 'u19_pipeline_ephys_element',
            'class_name': 'PreClusterParamSet',
            'method_field': 'precluster_method',
            'desc_field': 'paramset_desc',
            'param_field': 'params',
            'paramset_idx_field': 'paramset_idx',
            'param_set_hash_field': 'param_set_hash'
    },
        'processing': {
            'module': 'u19_pipeline_ephys_element',
            'class_name': 'ClusteringParamSet',
            'method_field': 'clustering_method',
            'desc_field': 'paramset_desc',
            'param_field': 'params',
            'paramset_idx_field': 'paramset_idx',
            'param_set_hash_field': 'param_set_hash'
      }
    },
    'imaging': { 
        'preprocessing': {
            'module': 'u19_pipeline_imaging_element',
            'class_name': 'PreProcessParamSet',
            'method_field': 'preprocess_method',
            'desc_field': 'paramset_desc',
            'param_field': 'params',
            'paramset_idx_field': 'paramset_idx',
            'param_set_hash_field': 'param_set_hash' 
    },
        'processing': {
            'module': 'u19_pipeline_imaging_element',
            'class_name': 'ProcessingParamSet',
            'method_field': 'processing_method',
            'desc_field': 'paramset_desc',
            'param_field': 'params',
            'paramset_idx_field': 'paramset_idx',
            'param_set_hash_field': 'param_set_hash' 
      }
    }
}


def upload_recording_parameters(modality=None, param_type=None, jsonfile_path=None, parameter_description=None, parameter_method=None):

    with open(jsonfile_path,'r') as infile:
        json_params = json.load(infile)

    # Declare datajoint table
    dict_this_table = field_dictionary[modality][param_type]
    element = dj.create_virtual_module(dict_this_table['module'],dict_this_table['module'])
    this_table = getattr(element, dict_this_table['class_name'])

    # Get last id of paramsets
    last_id = this_table.fetch(dict_this_table['paramset_idx_field'], order_by=(dict_this_table['paramset_idx_field'] + ' desc'), limit=1)
    last_id = int(last_id[0])

    # Create parameters dictionary
    param_dict = dict()
    param_dict[dict_this_table['method_field']] = parameter_method
    param_dict[dict_this_table['paramset_idx_field']] = last_id+1
    param_dict[dict_this_table['desc_field']] = parameter_description
    param_dict[dict_this_table['param_field']] = json_params
    param_dict[dict_this_table['param_set_hash_field']] = dict_to_uuid(json_params)
        
    #Insert parameters
    insert_new_params(this_table, param_dict, dict_this_table['paramset_idx_field'], dict_this_table['param_set_hash_field'])

    dj.conn().close()


def insert_new_params(cls, param_dict: dict, paramset_idx_field: str, param_set_hash_field: str):

    # Create parameters dictionary
    query = dict()
    query[param_set_hash_field] = param_dict[param_set_hash_field]
    q_param = cls & query

    if q_param:  # If the specified param-set already exists
        pname = q_param.fetch1(paramset_idx_field)
        if pname == param_dict[paramset_idx_field]:  # If the existed set has the same name: job done
            return
        else:  # If not same name: human error, trying to add the same paramset with different name
            raise dj.DataJointError(
                'The specified param-set already exists - name: {}'.format(pname))
    else:
        cls.insert1(param_dict)

if __name__ == "__main__":
    args = sys.argv[1:]
    print(args)
    # Expects a list with this order:
    # (modality, type, jsonfile_path, parameter_description, parameter_method)
    # type = ('preprocessing' or 'processing')
    upload_recording_parameters(modality=args[0], param_type=args[1], jsonfile_path=args[2], parameter_description=args[3], parameter_method=args[4])
