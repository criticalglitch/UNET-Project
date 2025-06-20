function generate_pixel_labels(trainPath, pixelPath, pixelLabelIDs, imageSize, classifier)
    fprintf("Pixel Label Images Started Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
    colmap = load("colormap.mat");
    class_dim = size(pixelLabelIDs, 2);
    % pre create destination directories
    folders = get_image_folders("GroundTruth");
    mkdir(pixelPath);
    for i = 1:length(folders)
        path = folders(i).imgPath;
        mkdir(path);
    end

    imdsTrain = imageDatastore(trainPath, IncludeSubfolders=true, LabelSource="foldernames");
    % imgResize = transform(imdsTrain, @(x) imresize(x, imageSize)); % resize images
    % imgIdx = transform(imgResize, @(x) rgb2ind(x, colmap.cm));

    files = imdsTrain.Files;
    cm = colmap.cm;
    parfor fileIdx = 1:length(files)
        file = string(files(fileIdx));
        destPath = string(replace(file, trainPath, pixelPath));
        if exist(destPath, 'file') ~= 2
            img = imread(file, "png");
            img = imresize(img, imageSize);
            img = rgb2ind(img, cm);
            [rows, cols] = size(img);

            dat = double(reshape(img, [], 1));
            ret = fastICA(dat', class_dim, "kurtosis", 0);

            componentMatrix = reshape(ret, rows, cols, class_dim);

            classes = reshape(classifier(componentMatrix), rows*cols, 1);
            newI = zeros(rows*cols, class_dim);
            for color = 1:class_dim
                locs = classes == color;
                c = pixelLabelIDs{color};
                newI(locs, 1) = c(1);
                newI(locs, 2) = c(2);
                newI(locs, 3) = c(3);
            end
            newI = reshape(newI, rows, cols, class_dim);

            imwrite(newI, destPath);
        end
    end

    fprintf("Pixel Label Images Finished Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end


