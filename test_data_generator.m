clc; clearvars; close all;

basePath = 'D:\DoctoralWork';
folders = get_image_folders(basePath, "Training");

% sampleRate = 25e6;
% %video = VideoWriter("specgram.mp4", 'MPEG-4');
% %video.FrameRate = 2;
% %open(video);
%         %writeVideo(video, getframe(gcf));
%close(video);

for folderIdx = 1:length(folders)
    imgPath = folders(folderIdx).imgPath;
    if ~exist(imgPath, 'dir')
        mkdir(imgPath);
    end
    dataPath = folders(folderIdx).dataPath;
    files = dir([ dataPath "*.sigmf-meta" ]);
    for fileIdx = 1:length(files)
        file = files(fileIdx).name;
        pngName = [imgPath file ".png"];
        if ~exist(strjoin(pngName, ""), 'file')
            fileToLoad = [ dataPath file ];
            [channels, sample_rate, signal_data] = load_sigmf_file(fileToLoad);
            signalFrequency = carrierfrequency(signal_data', sample_rate);
            gen_specgram(signal_data, signalFrequency, pngName);
        end
    end
end

% set(gca,"NextPlot","replacechildren");
% files = dir([sigmfCompPath '\*.sigmf-meta']);



% for fIdx = 1:100
%     dataFrame = readframe(basePath, 128, 1, 1, fIdx);
%     dataPerAntenna = reshapeperantenna(dataFrame, 4);
%     saveas(gcf, frameTitle, 'png');
% end

