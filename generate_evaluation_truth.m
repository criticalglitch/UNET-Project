function generate_evaluation_truth(testPath, pixelLabelIDs)
    arguments(Input)
        testPath (1, :) {mustBeTextScalar}
        pixelLabelIDs (1, :)
    end
    fprintf("Generating Evaluation Truth Images Started Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

    imagePath = fullfile("Images", "EvalTruth");
    if exist(imagePath, 'dir') ~= 7
        mkdir(imagePath);
    end
    colmap = load("colormap.mat");
    imdsTrain = imageDatastore(testPath, IncludeSubfolders=true, LabelSource="foldernames");

    files = imdsTrain.Files;
    cm = colmap.cm;
    class_dim = size(pixelLabelIDs, 2);

    parfor fileIdx = 1:length(files)
        file = string(files(fileIdx));
        destFile = replace(file, "Evaluation", "EvalTruth");
        if exist(destFile, 'file') ~= 2
            img = imread(file);
            img = rgb2ind(img, cm);
            [height, width, ~] = size(img);

            componentMatrix = zeros(height, width, class_dim);
            for row = 1:height
                dat = double(img(row, :));
                ret = fastICA(dat, class_dim, "kurtosis", 0);
                for class = 1:class_dim
                    componentMatrix(row, :, class) = ret(class, :);
                end
            end

            classes = reshape(classifier(componentMatrix), height * width, 1);
            newI = zeros(height*width, 3);
            for color = 1:class_dim
                locs = classes == color;
                c = pixelLabelIDs{color};
                newI(locs, 1) = c(1);
                newI(locs, 2) = c(2);
                newI(locs, 3) = c(3);
            end
            newI = reshape(newI, height, width, 3);

            imwrite(newI, destPath);
        end
    end

    fprintf("Generating Evaluation Truth Images Finished Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end