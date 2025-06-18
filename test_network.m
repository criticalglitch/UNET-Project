function test_network(testImagePath, imageSize, netTrained, fldrName, parameters)
    fprintf("Network Testing Started At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

    imdsTest = imageDatastore(testImagePath, IncludeSubfolders=true);
    testresize = transform(imdsTest, @(x) imresize(x, 'OutputSize', imageSize));
    fileIdx = 0;

    outName = fullfile(fldrName, "Output");
    if exist(outName, "dir") ~= 7
        mkdir(outName);
    end

    while hasdata(testresize)
        img = read(testresize);
        fileIdx = fileIdx + 1;
        d = dlarray(single(img), 'SSCB');
        output = predict(netTrained, d, InputDataFormats='SSCB');
        save(fullfile(outName, sprintf("output-%s-%04d.mat", parameters, fileIdx)), "output");
    end

    fprintf("Network Testing Finished At: %s\nem", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end