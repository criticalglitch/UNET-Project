function generate_test_images(testImagePath)
    fprintf("Test Images Started Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

    frameFiles = 100;
    frameLen = 128;
    set = 1;
    alpha = 1;
    nAntenna = 4;

    sample_rate = 25e6;

    if exist(testImagePath, 'dir') ~= 7
        mkdir(testImagePath);
    end

    parfor fileIdx = 1:frameFiles
        for antenna = 1:nAntenna
            pngName = fullfile(testImagePath, sprintf("Frame %03d - Antenna %d.png", fileIdx, antenna));
            if exist(pngName, 'file') ~= 2
                signal_data = read_rfchallenge_multisensor_frame(frameLen, set, alpha, fileIdx);
                channels = reshape_per_antenna(signal_data, nAntenna);
                signalFrequency = carrier_frequency(channels(antenna), sample_rate);
                generate_specgram_imagefile(signal_data, signalFrequency, pngName);
            end
        end
    end

    fprintf("Test Images Finished Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end