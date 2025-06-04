function generate_training_images(basePath)
    disp("Generating Training Images");

    folders = get_image_folders(basePath, "Training");
    
    for folderIdx = 1:length(folders)
        imgPath = folders(folderIdx).imgPath;
        if ~exist(imgPath, 'dir')
            mkdir(imgPath);
        end
        dataPath = folders(folderIdx).dataPath;
        files = dir(strjoin([ dataPath "*.sigmf-meta" ], ''));
        for fileIdx = 1:length(files)
            file = files(fileIdx).name;
            pngName = [imgPath file ".png"];
            if ~exist(strjoin(pngName, ""), 'file')
                fileToLoad = [ dataPath file ];
                [~, sample_rate, signal_data] = read_sigmf_iqdata(fileToLoad);
                signalFrequency = carrier_frequency(signal_data', sample_rate);
                generate_specgram_imagefile(signal_data, signalFrequency, pngName);
            end
        end
    end

end