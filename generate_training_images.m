function generate_training_images(imageSize)
    fprintf("Training Images Started Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

    folders = get_image_folders("Training");
    
    for folderIdx = 1:length(folders)
        imgPath = folders(folderIdx).imgPath;
        if ~exist(imgPath, 'dir')
            mkdir(imgPath);
        end
        dataPath = folders(folderIdx).dataPath;
        files = dir(fullfile(dataPath, "*.sigmf-meta"));
        parfor fileIdx = 1:length(files)
            file = files(fileIdx).name;
            pngName = fullfile(imgPath, strjoin([ file ".png"], ''));
            if exist(strjoin(pngName, ""), 'file') == 0
                fileToLoad = fullfile(dataPath, file);
                [~, sample_rate, signal_data] = read_sigmf_iqdata(fileToLoad);
                signalFrequency = carrier_frequency(signal_data', sample_rate);
                generate_specgram_imagefile(signal_data, signalFrequency, imageSize, pngName);
            end
        end
    end

    fprintf("Training Images Finished Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end