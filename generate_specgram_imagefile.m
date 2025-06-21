function generate_specgram_imagefile(signal_data, carrier_frequency, save_path, window, noverlap, nfft, threshold)
    arguments
        signal_data (1, :) {mustBeNumeric}
        carrier_frequency (1, 1) {mustBeNumeric, mustBePositive}
        save_path (1, 1) {mustBeText}
        window (1, 1) {mustBeInteger, mustBePositive} = 128
        noverlap (1, 1) {mustBeInteger, mustBePositive} = 64
        nfft (1, 1) {mustBeInteger, mustBePositive} = 128
        threshold (1, 1) {mustBeNumeric} = -Inf
    end

    colmap = load("colormap.mat");

    spectrogram(signal_data, window, noverlap, nfft, carrier_frequency, MinThreshold=threshold);
    colormap(colmap.cm);
    
    set(gca, 'XTick', []); % point = increment
    set(gca, 'YTick', []); % range + increment
    xlabel("");
    ylabel("");
    colorbar('off');
    

    exportgraphics(gca, strjoin(save_path, ''), 'Resolution', 300);
end