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
    parfor fileIdx = 1:length(files) % par
        file = string(files(fileIdx));
        destPath = string(replace(file, trainPath, pixelPath));
        if exist(destPath, 'file') ~= 2
            img = imread(file, "png");
            img = imresize(img, imageSize);
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

    fprintf("Pixel Label Images Finished Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end


