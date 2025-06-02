% read a datafile
% possibly split into single channels
% perform ICA on the channel
% generate a spectrograph

basePath = 'D:\DoctoralWork\';
folders = get_image_folders(basePath, "GroundTruth");

for fIdx = 1:length(folders)
    imgPath = folders(fIdx).imgPath;
    if ~exist(imgPath, 'dir')
        mkdir(imgPath);
    end
    dataPath = folders(fIdx).dataPath;
    files = dir([ dataPath '*.sigmf-meta' ]);
    for fileIdx = 1:length(files)
        file = files(fileIdx).name;
        pngName = [imgPath file ".png"];
        if ~exist(strjoin(pngName, ""), 'file')
            [channels, sample_rate, signal_data] = read_sigmf_iqdata([ dataPath file ]);
            signalFrequency = carrier_frequency(signal_data', sample_rate);
            
            % ICA HERE
            sep = ica_fastica(signal_data, 2);

            generate_specgram_pixelimage(signal_data, signalFrequency, sep, pngName);

            return;
        end
    end
end