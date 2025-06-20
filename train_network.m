function train_network(trainImagePath, pixelImagePath, imageSize, classNames, pixelLabelIDs, optim, learn_rate, max_epochs, mini, fldrName, parameters)
    fprintf("Network Training Started At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
    
    % create the training image datastore for the spectrograms    
    imdsTrain = imageDatastore(trainImagePath, IncludeSubfolders=true, LabelSource="foldernames");

    % create the pixel data store
    pxds = pixelLabelDatastore(pixelImagePath, classNames, pixelLabelIDs, IncludeSubfolders = true);

    h = imageSize(1);
    w = imageSize(2);

    % define the image size and classes for the network
    netImgSize = [ h w 3 ]; % [ Height x Width x Channels ]
    numClasses = size(classNames, 2);

    trainresize = transform(imdsTrain, @(x) imresize(x, 'OutputSize', imageSize)); % ensure all images are the same size
    combinedTrain = combine(trainresize, pxds); % combine training data with pixel datastore

    % initialize unet
    unetNetwork = unet(netImgSize, numClasses);

    lossFcn = "index-crossentropy"; % loss function definition (classification: "crossentropy", "index-crossentropy", "binary-crossentropy"), (regression: "mae", "mse", "huber")
    options = trainingOptions(optim, ...
                              InitialLearnRate=learn_rate, ...
                              MaxEpochs=max_epochs, ...
                              CheckpointFrequency=1, ...
                              InputDataFormats='SSCB', ...
                              TargetDataFormats='SSCB', ...
                              VerboseFrequency=1, ...
                              MiniBatchSize=mini, ...
                              ExecutionEnvironment='gpu', ...
                              Plots="training-progress");

    save(fullfile(fldrName, sprintf("debug-%s.mat", parameters)));
    train_concat = fullfile(fldrName, sprintf("trainnet-%s.mat", parameters));
    [netTrained, ~] = trainnet(combinedTrain, unetNetwork, lossFcn, options); % train
    currentfig = findall(groot, 'Tag', 'DEEPMONITOR_UIFIGURE'); % grab figure
    exportgraphics(currentfig, fullfile(fldrName, "trainloss.png"));
    save(train_concat, 'netTrained');
    
    fprintf("Network Training Finished At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end