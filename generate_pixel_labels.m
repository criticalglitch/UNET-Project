function generate_pixel_labels(trainPath, pixelPath, imageSize, classifier)
    fprintf("Pixel Label Images Started Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
    colmap = load("colormap.mat");
    imdsTrain = imageDatastore(trainPath, IncludeSubfolders=true, LabelSource="foldernames");
    imgResize = transform(imdsTrain, @(x) imresize(x, imageSize)); % resize images
    imgIdx = transform(imgResize, @(x) rgb2ind(x, colmap.cm));

    % pre create destination directories
    if exist(pixelPath, "dir") ~= 7
        mkdir(pixelPath);
    end

    %recursive directory creationu
    folders = dir(strjoin([ trainPath '**/*.*'], ''));
    folders = folders([folders(:).isdir] == 1);
    folders = folders(~ismember({folders(:).name}, {'.', '..'}));
    for i = 1:length(folders)
        path = [folders(i).folder '/' folders(i).name];
        path = replace(path, trainPath, pixelPath);
        mkdir(path);
    end

    fileIdx = 0;
    while hasdata(imgIdx)
        img = read(imgIdx);
        fileIdx = fileIdx + 1;

        [rows, cols] = size(img);

        dat = double(reshape(img, [], 1));
        ret = fastICA(dat', 2);

        componentMatrix = reshape(ret, rows, cols, 2);

        classes = classifier(componentMatrix);

        newI = uint8(classes(:, :, 1));
        newI = cat(3, newI, newI, newI) * 255;

        origPath = imdsTrain.Files(fileIdx);
        destPath = string(replace(origPath, trainPath, pixelPath));

        imwrite(newI, destPath);
    end

    fprintf("Pixel Label Images Finished Generating At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end


