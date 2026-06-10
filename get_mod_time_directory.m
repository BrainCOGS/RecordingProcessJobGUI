function folder_time = get_mod_time_directory(folder)


info = dir(folder);

folder_datetime = info(1).date;

folder_time = folder_datetime(13:17);

end




