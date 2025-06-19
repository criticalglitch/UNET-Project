function generate_test_images(testImagePath)
    fprintf("Test Images Started Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
    
    alpha_files = 25;
    frameFiles = 100;
    frameLen = 128;
    set = 1;
    nAntenna = 4;

    sample_rate = 25e6;

    if exist(testImagePath, 'dir') ~= 7
        mkdir(testImagePath);
    end

    for alpha = 1:alpha_files
        parfor fileIdx = 1:frameFiles
            for antenna = 1:nAntenna
                pngName = fullfile(testImagePath, sprintf("l%03ds%02da%02df%03dc%d.png", frameLen, set, alpha, fileIdx, antenna));
                if exist(pngName, 'file') ~= 2
                    signal_data = read_rfchallenge_multisensor_frame(frameLen, set, alpha, fileIdx);
                    channels = reshape_per_antenna(signal_data, nAntenna);
                    signalFrequency = carrier_frequency(channels(antenna), sample_rate);
                    generate_specgram_imagefile(signal_data, signalFrequency, pngName);
                end
            end
        end
    end

    fprintf("Test Images Finished Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end