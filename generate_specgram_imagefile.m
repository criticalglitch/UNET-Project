function generate_specgram_imagefile(signal_data, carrier_frequency, imageSize, save_path, window, noverlap, nfft, threshold)
    arguments % limits what values each argument can hold (1, 1) = scalar (1 x 1 matrix)
        signal_data (1, :) {mustBeNumeric}
        carrier_frequency (1, 1) {mustBeNumeric, mustBePositive}
        imageSize (1, 2) {mustBeNumeric, mustBePositive}
        save_path (1, 1) {mustBeText}
        window (1, 1) {mustBeInteger, mustBePositive} = 128
        noverlap (1, 1) {mustBeInteger, mustBePositive} = 64
        nfft (1, 1) {mustBeInteger, mustBePositive} = 128
        threshold (1, 1) {mustBeNumeric} = -Inf
    end

    colmap = load("colormap.mat", 'cm');
    Height = imageSize(1);
    Width = imageSize(2);

    spectrogram(signal_data, window, noverlap, nfft, carrier_frequency, MinThreshold=threshold);
    colormap(colmap.cm);
    

    set(gca, 'XTick', []); % point = increment
    set(gca, 'YTick', []); % range + increment
    xlabel("");
    ylabel("");
    colorbar('off');

    exportgraphics(gca, strjoin(save_path, ''), Units="pixels", Width=Width, Height=Height);
end