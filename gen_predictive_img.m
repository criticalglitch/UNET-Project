function gen_predictive_img(testPath, unetDir, imgSize, classNames)
    fprintf("Generating Predicted Images Started At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

    %  Eval   Output
    % imgDs   fileDs
    %   |       |
    %   |       |
    %   v       v
    % resize classMatrix
    %   |       |
    %   |       |
    %   v       v
    % combineStores
    %      |
    %      |
    %      v
    % labeledImage

    imdsTest = imageDatastore(testPath, IncludeSubfolders=true);                % Read from Test Images Directory
    testresize = transform(imdsTest, @(x) imresize(x, 'OutputSize', imgSize));  % Resize all images to match size
    wrappedImg = transform(testresize, @(x) {x});                               % Wrap in a Cell

    fdsOut = fileDatastore(fullfile(unetDir, "Output"), "FileExtensions", [ ".mat" ], "ReadFcn", @load); % Read from Unet Output Directory all .mat Files and load each one
    sigProb = transform(fdsOut, @(x) extractdata(x.output(:, :, 1)));                                               % Read Signal Probability from file and converts from dlarray
    sig = transform(sigProb, @(x) x >= 0.5);                                                                        % Checks if probability is greater than 50% and assigns 1 or 0 respectively
    sigClass = transform(sig, @(x) 2 - x);                                                                          % Creates classes from 1's and 0's into 1's and 2's
    wrappedSigClass = transform(sigClass, @(x) {x});                                                                % Wrap in a Cell

    combined = combine(wrappedImg, wrappedSigClass);                                                                % Combine cell arrays of image and signal class
    overlayed = transform(combined, @(x) labeloverlay(x{1}, categorical(x{2}, 1:length(classNames), classNames), "Colormap", [ 1 1 1 ; 0 0 0 ], Transparency=0));  % Create overlay image from the two cell arrays

    fldrName = fullfile(unetDir, "OverlayImages");
    if exist(fldrName, "dir") ~= 7
        mkdir(fldrName);
    end

    fileIdx = 0;
    while hasdata(overlayed)
        img = read(overlayed);
        fileIdx = fileIdx + 1;

        fileName = imdsTest.Files(fileIdx);
        destFile = string(replace(fileName, testPath, fldrName));

        imwrite(img, destFile);
    end

    fprintf("Generating Predicted Images Ended At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end