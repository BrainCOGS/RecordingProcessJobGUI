# @RecordingProcessJobGUI

`RecordingProcessJobGUI` — the **rig-side GUI that registers a recording into the
automatic processing pipeline** and manages the processing jobs that run on it.
One copy runs on each recording rig, configured for that rig by
`system_conf_job_gui.json`.

## What it does

After a recording finishes on the rig, a technician:

1. **Registers the recording** — picks the recording directory found under the
   configured root, optionally links it to the behavior session it belongs to,
   and presses Create. The GUI ROBOCOPYs the raw data from the rig's local disk
   to cup and inserts `recording.Recording` (plus its session part-table and
   default params) in one transaction.
2. **Chooses parameters** — assigns a pre-processing step list and a processing
   paramset to each **fragment** of the recording (a probe for
   electrophysiology, a field-of-view for imaging), either per fragment or the
   same for all.
3. **Watches the jobs** — the pipeline picks the registered work up and runs it.
   The GUI shows each job's status history, and can rerun a job, rerun it with
   different parameters, open its logs, or launch the external viewers (IBL
   ephys atlas, phy, suite2p).

Parameters themselves can be authored in the GUI (Create Parameters tab) and
written back to the database.

> **Note on the two write paths.** The Create Parameters tab writes in two
> different ways, and they are not symmetric. `RegisterPreParamList` inserts the
> pre-process step list and its steps directly through DataJoint, in a single
> transaction. `writeParametersDB`, by contrast, inserts only the optional *new
> method* row from MATLAB — the paramset itself is inserted by
> `PythonScripts/upload_params.py`, which picks the target table, assigns
> `paramset_idx` and computes `param_set_hash` on its own. So paramset creation
> requires python (`app.py_enabled`) and is **not** covered by a transaction.

## Launching

```matlab
app = RecordingProcessJobGUI;
```

The constructor runs `configParams` (table/field registry and cup data paths),
`createComponents` (builds the UI), then `startupFcn` (builds the DataJoint
relations, validates the configuration, fills the GUI).

If any field of `system_conf_job_gui.json` is empty, the GUI starts in an
**unconfigured** state — the header label turns red and reads "Configuration
needed", and only the System Configuration tab is useful until it is filled in.

## Configuration

`system_conf_job_gui.json` at the repo root:

| Field | Meaning |
|---|---|
| `System` | This recording system's name, e.g. `185A-Recording` |
| `RecordingModality` | `electrophysiology` or `imaging` |
| `RecordingRootDirectory` | Local disk searched for recording directories, e.g. `D:\NPX_DATA` |
| `BehaviorRig` | Associated behavior rig(s) — one name or a list |

`checkConfiguration` loads it into `app.Configuration` and always normalizes
`BehaviorRig` to a cell array. `postConfigurationActions` then walks
`RecordingRootDirectory` (via `dirwalk`, filtering on the modality's file
extensions) to populate the recording-directory dropdown.

## Tabs

| Tab | Title | Key methods |
|---|---|---|
| 1 | Add Recording | `createRecordingButton`, `createRecording`, `copyRecording`, `createDefaultParamsRecord`, `findLikelyBehaviorSessionFromRecDir` |
| 2 | Select Parameters | `fillParams2Select`, `ParamSetSelected`, `ParamListSelected`, `RegisterParamsFragmentClicked`, `checkParamSelection` |
| 3 | Recording Table | `fillRecordingTable`, `recordingTableSelected`, `filterTable` |
| 4 | Manage Processing Jobs | `fillJobTable`, `jobTableSelected`, `fillJobStatusTable`, `RerunJob`, `RunJobDiffParams`, `CreateNewJob`, `OpenLog`, `OpenExtGUI` |
| 5 | Create Parameters | `RegisterPreParamList`, `writeParametersDB`, `UploadParamJsonFile`, `getMethods` |
| 6 | System Configuration | `checkConfiguration`, `startConfiguration`, `configureSystem`, `addRig2System`, `postConfigurationActions` |

A secondary **surgery figure** (`createComponentsSurgeryFigure`, `addSurgeryData`,
`registerSurgery`) is raised from Tab 1 when the recording's subject has no
`action.Surgery` record yet.

## Files

```
@RecordingProcessJobGUI/
├── RecordingProcessJobGUI.m          Class def: properties, constants, method list
│
│   Startup and configuration
├── startupFcn.m                      Build DataJoint relations, validate config, fill GUI
├── configParams.m                    Per-modality table/field registry, cup data paths
├── createComponents.m                Builds the whole UI (all six tabs) and wires callbacks
├── createComponentsSurgeryFigure.m   Builds the surgery sub-figure
├── getPythonEnv.m                    Locate the EnvAutoPipeGUI and iblenv conda envs
├── getParamsFromMatlab.m             Fetch paramsets/step lists without python
├── getDefaultParamsMod.m             Default pre-params and params for the modality
│
│   Tab 1 — Add Recording
├── createRecordingButton.m           Create button → validate, then createRecording
├── createRecording.m                 Copy to cup and insert recording.Recording (transaction)
├── createDefaultParamsRecord.m       Build the recording.DefaultParams record(s)
├── copyRecording.m                   ROBOCOPY the local directory to cup
├── checkLocaldirSessionMatch.m       Ask whether the local dir matches the session
├── checkBoxSessionRecording.m        "Is there a behavior session" toggle
├── DefaultParamsCheckBoxToggle.m     Default-parameters toggle
├── controlEnables.m                  Bulk enable/disable of the tab's widgets
├── fillRecordingDirectories.m        Fill the recording-directory dropdown
├── findLikelyBehaviorSessionFromRecDir.m  Guess the session matching a recording dir
├── restoreColorSessionDropDown.m     Reset the guessed-session highlight
│
│   Surgery sub-figure
├── addSurgeryData.m                  Raise the surgery figure for a subject
├── addInsertionDevice.m              Add an implanted-device row
├── deleteInsertionDevice.m           Remove an implanted-device row
├── registerSurgery.m                 Write the surgery and its devices to the DB
├── closeSurgeryFigure.m              Close/teardown the surgery figure
│
│   Tab 2 — Select Parameters
├── fillUserParams.m                  Fill the user-params dropdown
├── fillParams2Select.m               Fill the selectable params for a modality
├── ParamSetSelected.m                Processing paramset chosen
├── ParamListSelected.m               Pre-processing step list chosen
├── PreparamStepSelected.m            Step within a list chosen
├── SamePreParamCheckClicked.m        "Same pre-params for all fragments"
├── SameParamCheckClicked.m           "Same params for all fragments"
├── RegisterPreparamFragmentClicked.m Assign the pre-param list to a fragment
├── RegisterParamsFragmentClicked.m   Assign the paramset to a fragment
├── checkParamSelection.m             Gate the create button on a complete selection
├── SelectedListBoxFragmentRec.m      Fragment listbox selection (pre-params side)
├── SelectedListBoxFragmentRec2.m     Fragment listbox selection (params side)
│
│   Tab 3 / Tab 4 — Recording and Job tables
├── fillRecordingTable.m              Fill the recording table
├── recordingTableSelected.m          Row selected → show recording status history
├── fillJobTable.m                    Fill the job table
├── jobTableSelected.m                Row selected → show job details
├── fillJobStatusTable.m              Fill the job status-history table
├── filterTable.m                     Apply the subject/user/status filters
├── setStyleCellsTable.m              Apply the red/green cell styles
├── RerunJob.m                        Reset a job's status so the pipeline retries it
├── RunJobDiffParams.m                Rerun a job with different parameters
├── CreateNewJob.m                    Clone a job (new job_id, new params)
├── OpenLog.m                         Open the job's error/output log
├── OpenExtGUI.m                      Launch an external python viewer
├── OpenExtGUI2.m                     Launch an external python viewer (second entry point)
│
│   Tab 5 — Create Parameters
├── checkBoxPreParamMethod.m          Pre-process method checkbox
├── checkBoxParamMethod.m             Process method checkbox
├── UploadParamJsonFile.m             Load a paramset from a JSON file
├── CreatePreparamStepSelected.m      Step selected while building a list
├── AddPreParamStepNewList.m          Append a step to the new list
├── DeleteStepClicked.m               Remove a step
├── MoveStepOrderClicked.m            Reorder steps (renumbers step_number)
├── RegisterPreParamList.m            Assemble the ordered pre-process step list
├── writeParametersDB.m               Insert the new paramsets/step lists (transaction)
├── getMethods.m                      Fetch the available methods for the modality
├── loadParamsFile.m                  Read the .mat written by read_params.py
├── splitDescriptionColumnParams.m    Split the params description column
│
│   Tab 6 — System Configuration
├── checkConfiguration.m              Load and validate system_conf_job_gui.json
├── startConfiguration.m              Begin editing the configuration
├── configureSystem.m                 Save the configuration
├── postConfigurationActions.m        Discover recording dirs, fill dependent widgets
├── selectRecordingRootDirectory.m    Pick the recording root directory
├── addRig2System.m                   Add a behavior rig to this system
├── dropRig2System.m                  Remove a behavior rig
│
│   Fetch from the DB and fill a widget
├── fillRecordingUser.m               Users (Manage Jobs tab)
├── fillRecordingUserRT.m             Users (Recording Table tab)
├── fillRecordingSubject.m            Subjects (Manage Jobs tab)
├── fillRecordingSubjectRT.m          Subjects (Recording Table tab)
├── fillSubjects.m                    Subjects for the selected user
├── fillSessions.m                    Behavior sessions for this rig
├── fillUsers.m                       Active GUI users
├── fillPreParamsSets.m               Pre-process paramsets
├── fillRecordingModality.m           Recording modalities
├── fillParams.m                      Processing paramsets
├── fillDefaultParams.m               Default params for the modality
│
│   Global
├── FillEverything.m                  Refresh every table and filter widget
└── updateBusyLabel.m                 Busy/ready indicator (false = busy, true = ready)
```

`@RecordingProcessJobGUI` is a MATLAB *class folder*: the classdef lives in
`RecordingProcessJobGUI.m` and every other `.m` file is one method of the class,
each with a help-block header.

## Modalities

Almost every parameter-related property is a struct keyed by
`recording_modality` — `electrophysiology` or `imaging` — because the two use
different DataJoint element tables and different field names:

| Property | Purpose |
|---|---|
| `param_table_names` | Processing paramset table per modality |
| `preparam_table_names` | Pre-processing paramset table per modality |
| `preparam_steps_table_names` | Pre-process step-list table + its field names |
| `preparam_steps_step_table_names` | Step-within-list table + its field names |
| `param_methods_table_names` | Processing/clustering method table |
| `RootDirectories` / `RootProcessedDirectories` | Raw/processed roots on cup, read from `lab.DjCustomVariables` |
| `AllFileExtensions` | Extensions that mark a recording directory (`\g0` for ephys; `.tif`/`.tiff`/`.avi` for imaging) |
| `DefaultImplantationDevice` | `NeuroPixel_Probe_v1` for ephys, `no_device` for imaging |

`configParams` is where all of this is defined — read it first when adding a
modality.

## Dependencies

- **DataJoint** (`modDataJoint/`) over MySQL/MariaDB (`mym-mariadbconn/`) — every
  table access. `connect_tech()` opens the connection; `DB_PREFIX` is `u19_`.
- **U19 pipeline schemas** — `recording` (Recording, Status, Modality,
  DefaultParams, RecordingBehaviorSession, RecordingRecordingSession),
  `recording_process` (Processing, Status, LogStatus), `subject`, `lab`,
  `action.Surgery`, `pipeline_ephys_element.*`, `pipeline_imaging_element.*`.
- **Python** — conda envs `EnvAutoPipeGUI` and `iblenv`; scripts in
  `PythonScripts/` (`read_params.py`, `upload_params.py`, `open_phy.BAT`,
  `open_suite2p.BAT`, `iblapps-master/`).
- **`dirwalk/`** — recursive recording-directory discovery.
- **ROBOCOPY** — copying recordings to cup (Windows).
- **Repo-root helpers** — `fetchDataDJTable`, `fetch_table_except`,
  `convertTable2Categorical`, `loadJSONfile`, `saveJSONfile`, `catstruct`,
  `copy_gui_vars` / `load_gui_vars`, `find_datestr_recording_directory`,
  `get_mod_time_directory`.
- **Assets** — `brain_cogs_on_white_small_brain_cogs_on_white.png`, `reload.png`,
  `OneDrive_Folder_Icon.svg.png`.
