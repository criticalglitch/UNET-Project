function generate_specgram_imagefile(signal_data, carrier_frequency, save_path)
    spectrogram(signal_data, 128, 64, 128, carrier_frequency);
    set(gca, 'XTick', []); % point = increment
    set(gca, 'YTick', []); % range + increment
    xlabel("");
    ylabel("");
    colorbar('off');
    exportgraphics(gca, strjoin(save_path, ''), 'Resolution', 300);
end