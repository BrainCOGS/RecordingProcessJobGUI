import sys
import os

this_dir = os.path.dirname(__file__)
os.chdir(this_dir)
import datajoint as dj

# CLI counterpart of the MATLAB RegisterPreParamList callback: registers an ordered list of
# existing pre-processing paramsets (PreClusterParamSteps + .Step for ephys,
# PreprocessParamSteps + .Step for imaging). The paramsets themselves are inserted first with
# upload_params.py; this only links them in order.

dj.conn()

steps_dictionary = {
    'electrophysiology': {
        'module': 'u19_pipeline_ephys_element',
        'method_table': 'PreClusterMethod',
        'method_field': 'precluster_method',
        'paramset_table': 'PreClusterParamSet',
        'steps_table': 'PreClusterParamSteps',
        'steps_idx_field': 'precluster_param_steps_id',
        'steps_name_field': 'precluster_param_steps_name',
        'steps_desc_field': 'precluster_param_steps_desc',
    },
    'imaging': {
        'module': 'u19_pipeline_imaging_element',
        'method_table': 'PreprocessMethod',
        'method_field': 'preprocess_method',
        'paramset_table': 'PreprocessParamSet',
        'steps_table': 'PreprocessParamSteps',
        'steps_idx_field': 'preprocess_param_steps_id',
        'steps_name_field': 'preprocess_param_steps_name',
        'steps_desc_field': 'preprocess_param_steps_desc',
    }
}


def register_preparam_steps(modality=None, steps_name=None, steps_desc=None, paramset_idxs=None):

    d = steps_dictionary[modality]
    element = dj.create_virtual_module(d['module'], d['module'])
    paramset_table = getattr(element, d['paramset_table'])
    steps_table = getattr(element, d['steps_table'])

    # Every referenced paramset must exist (FK on the Step part table)
    for idx in paramset_idxs:
        if not (paramset_table & {'paramset_idx': idx}):
            raise dj.DataJointError('paramset_idx {} does not exist in {}'.format(idx, d['paramset_table']))

    last_id = steps_table.fetch(d['steps_idx_field'], order_by=(d['steps_idx_field'] + ' desc'), limit=1)
    new_id = int(last_id[0]) + 1 if len(last_id) else 1

    steps_record = {d['steps_idx_field']: new_id,
                    d['steps_name_field']: steps_name,
                    d['steps_desc_field']: steps_desc}
    step_records = [{d['steps_idx_field']: new_id, 'step_number': i + 1, 'paramset_idx': idx}
                    for i, idx in enumerate(paramset_idxs)]

    # One transaction so the list header is never left without its steps
    with dj.conn().transaction:
        steps_table.insert1(steps_record)
        steps_table.Step.insert(step_records)

    print('registered', d['steps_table'], new_id, '->', [(r['step_number'], r['paramset_idx']) for r in step_records])
    dj.conn().close()
    return new_id


if __name__ == "__main__":
    args = sys.argv[1:]
    print(args)
    # Expects: (modality, steps_name, steps_desc, paramset_idx_1 [paramset_idx_2 ...]) in run order
    # ex: python register_preparam_steps.py electrophysiology catgt_dredge "catgt then dredge" 2 7
    register_preparam_steps(modality=args[0], steps_name=args[1], steps_desc=args[2],
                            paramset_idxs=[int(a) for a in args[3:]])
