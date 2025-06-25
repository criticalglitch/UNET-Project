function generate_test_images(testImagePath)
    fprintf("Test Images Started Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

    frameLen = 128; % 128 complex-valued pairs
    setIdx = 1; % 1, only set 1 is used of 20
    alpha_files = 25; % 25, the amount of SINR ratios (-18 to 12 dB)
    frameFiles = 100; % 100, the amount of frames per alpha
    nAntenna = 4; % 4 antenna channels

    sample_rate = 25e6;

    if exist(testImagePath, 'dir') ~= 7
        mkdir(testImagePath);
    end

    for alpha = 1:alpha_files % alpha then frame then channel
        parfor fileIdx = 1:frameFiles
            for antenna = 1:nAntenna
                pngName = fullfile(testImagePath, sprintf("l%03ds%02da%02df%03dc%d.png", frameLen, setIdx, alpha, fileIdx, antenna));
                if exist(pngName, 'file') ~= 2
                    signal_data = read_rfchallenge_multisensor_frame(frameLen, setIdx, alpha, fileIdx);
                    channels = reshape_per_antenna(signal_data, nAntenna);
                    signal = channels(antenna, :); % grabs all data per antenna channel
                    signal = signal(:)'; % vectorize and transpose
                    signalFrequency = carrier_frequency(signal, sample_rate);
                    generate_specgram_imagefile(signal, signalFrequency, pngName, 128, 64, 256, -Inf); % Thresholding = 20
                end
            end
        end
    end

    fprintf("Test Images Finished Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end