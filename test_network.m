function test_network(testImagePath, imageSize, netTrained, fldrName)
    fprintf("Network Testing Started At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

    imdsTest = imageDatastore(testImagePath, IncludeSubfolders=true);
    fileIdx = 0;

    outName = fullfile(fldrName, "Output");
    if exist(outName, "dir") ~= 7
        mkdir(outName);
    end

    while hasdata(imdsTest)
        img = read(imdsTest);
        fileIdx = fileIdx + 1;
        d = dlarray(gpuArray(single(img)), 'SSCB');
        output = predict(netTrained, d, InputDataFormats='SSCB', Acceleration="mex");
        save(fullfile(outName, sprintf("%s-%04d.mat", replace(fldrName, "UNet", "output"), fileIdx)), "output");
    end

    fprintf("Network Testing Finished At: %s\nem", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end
