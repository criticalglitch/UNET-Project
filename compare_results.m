function compare_results(truthFolder, outputFolder)
    fprintf("Compiling Results Started At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

    imdsTruth = imageDatastore(truthFolder);
    imdsOutput = imageDatastore(fullfile(outputFolder, "OverlayImages"));

    compare = combine(imdsTruth, imdsOutput);
    diffed = transform(compare, @(x) imabsdiff(x{1}, x{2}));
    percentDiff = transform(diffed, @(x) length(x(x == 0)) / numel(x));

    idx = 0;
    accuracies = zeros(length(imdsTruth.Files));
    while hasdata(percentDiff)
        % read from percentDiff and store the result as accuracy
        accuracy = read(percentDiff);
        % increment idx by 1
        idx = idx + 1;
        % display the accuracy to the console
        disp(accuracy);
        % store it in the accuracies array at the specified index
        accuracies(idx) = accuracy;
    end

    disp("===================");
    fprintf("  Mean: %0.3f\n", mean(accuracies));
    fprintf("Median: %0.3f\n", median(accuracies));
    fprintf("  Mode: %0.3f\n", mode(accuracies));
    fprintf("StdDev: %0.3f\n", std(accuracies));
    fprintf(" Quart: %0.3f\t%0.3f\t%0.3f\t%0.3f\n", quantile(accuracies, 4));
    disp("===================");
    fprintf("Compiling Results Started At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end
