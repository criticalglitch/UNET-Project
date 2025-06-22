clearvars;
alpha_files = 25;
frameFiles = 100;
frameLen = 128;
setIdx = 1;
nAntenna = 4;

sample_rate = 25e6;

signal_data = read_rfchallenge_multisensor_frame(frameLen, setIdx, 1, 1);
channels = reshape_per_antenna(signal_data, nAntenna);
signal = channels(1, :);
signal = signal(:)';
signalFrequency = carrier_frequency(signal, sample_rate);

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