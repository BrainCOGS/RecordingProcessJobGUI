function dir_dt = find_datestr_recording_directory(directory)

dir_dt = NaT;

dir_pieces = split(directory, "/");

%% Find all expressions that looks like date in dir
expressions = {'\d{8}', '\d{4}-\d{2}-\d{2}', '\d{4}-\d{2}-\d{4}'}; 
all_numdate_matches = {};
for i =1:length(dir_pieces)

    for j=1:length(expressions)

        matches = regexp(dir_pieces{i}, expressions{j}, 'match');
        all_numdate_matches = [all_numdate_matches matches];
    end
end


%% Extract date from numeric expressions in dir
date_formats = {'yyyyMMdd','MMddyyyy','MMddyy','dd-MM-yyyy','yyyy-MM-dd','MM-dd-yyyy'};
for i =1:length(all_numdate_matches)

    for j=1:length(date_formats)

        try
            dir_dt = datetime(all_numdate_matches{i}, "InputFormat", date_formats{j});
            break;
        catch
        end
    end
    if ~isnat(dir_dt)
        break;
    end

end


end

