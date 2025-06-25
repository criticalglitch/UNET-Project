clearvars;
addpath("../"); % makes parent directory functions available

cd("..\");
    [ ~, sample_rate, signal ] = read_sigmf_iqdata("Radio Data\Training\CommSignal3\CommSignal2_vs_CommSignal3_sep_train_0000.sigmf-meta");
cd("Extra");

signalFrequency = carrier_frequency(signal', sample_rate);

% generate_specgram_imagefile(channels(antenna), signalFrequency, pngName, 128, 64, 256, 20);
noise = zeros(1, length(signal)) - 3; % median of estimated SINR
signal_noise = snr(signal, noise); % mixed signal estimated snr

colmap = load("colormap.mat");

% figure;
spectrogram(signal, 128, 64, 256, signalFrequency, MinThreshold=-inf);
colormap(colmap.cm);
title(sprintf('SNR: %d dB', signal_noise));

set(gca, 'XTick', []);
set(gca, 'YTick', []);
xlabel("");
ylabel("");
colorbar('off');
exportgraphics(gca, 'snr.png', 'Resolution', 300);