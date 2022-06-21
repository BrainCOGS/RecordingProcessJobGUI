
function fillDefaultParams(app)

modality = app.Configuration.RecordingModality;

[default_preparams, default_params] = getDefaultParamsMod(app);

default_preparams = default_preparams(:, app.COLUMNS_DEF_PREPARAMS_TABLE);
app.DefaultPreParamTable.Data = cellfun(@string, table2cell(default_preparams));

default_params = default_params(:, app.COLUMNS_DEF_PARAMS_TABLE);
app.DefaultParamTable.Data = cellfun(@string, table2cell(default_params));


end