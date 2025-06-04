function generate_pixel_labels(trainPath, pixelPath, imageSize)
    disp("Generating Pixel Images");
    
    imdsTrain = imageDatastore(trainPath, IncludeSubfolders=true, LabelSource="foldernames");
    imgResize = transform(imdsTrain, @(x) imresize(x, imageSize)); % resize images
    imgIdx = transform(imgResize, @(x) rgb2ind(x, parula));

    % pre create destination directories
    if exist(pixelPath, "dir") ~= 7
        mkdir(pixelPath);
    end

    fileIdx = 0;
    while hasdata(imgIdx)
        img = read(imgIdx);
        fileIdx = fileIdx + 1;

        [rows, cols] = size(img);

        dat = double(reshape(img, [], 1));
        ret = fastICA(dat', 2);

        out = reshape(ret, rows, cols, 2);

        minnn = min(min(min(out)));
        maxxx = max(max(max(out)));
        mid = (maxxx + minnn) / 2;
        bin = out > mid;

        newI = uint8(bin(:, :, 1));
        newI = cat(3, newI, newI, newI) * 255;

        origPath = imdsTrain.Files(fileIdx);
        destPath = string(replace(origPath, trainPath, pixelPath));

        imwrite(newI, destPath);
    end
end


