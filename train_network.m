function train_network(fldrArgs, imageSize, classNames, pixelLabelIDs, trainParams)
    fprintf("Network Training Started At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
    modelFile = fullfile(fldrArgs.OutputFolder, fldrArgs.ModelFile);
    if exist(modelFile, 'file') ~= 2
        % create the training image datastore for the spectrograms    
        imdsTrain = imageDatastore(fldrArgs.TrainImages, IncludeSubfolders=true, LabelSource="foldernames");

        % create the pixel data store
        pxds = pixelLabelDatastore(fldrArgs.LabelImages, classNames, pixelLabelIDs, IncludeSubfolders = true);
        
        % add train-test split for validation
        [imdsTrainSplit, imdsValSplit, pxdsTrainSplit, pxdsValSplit] = partition_semantic_segmentation_data(imdsTrain, pxds, 0.8);

        combinedTrain = combine(imdsTrainSplit, pxdsTrainSplit);
        combinedVal = combine(imdsValSplit, pxdsValSplit);

        h = imageSize(1);
        w = imageSize(2);

        % define the image size and classes for the network
        netImgSize = [ h w 3 ]; % [ Height x Width x Channels ]
        numClasses = size(classNames, 2);

        % initialize unet
        unetNetwork = unet(netImgSize, numClasses);

        lossFcn = "binary-crossentropy"; % loss function definition (classification: "crossentropy", "index-crossentropy", "binary-crossentropy"), (regression: "mae", "mse", "huber")
        options = trainingOptions(trainParams.Optimizer, ...
                                  InitialLearnRate=trainParams.LearnRate, ...
                                  MaxEpochs=trainParams.MaxEpochs, ...
                                  CheckpointFrequency=1, ...
                                  InputDataFormats='SSCB', ...
                                  TargetDataFormats='SSCB', ...
                                  VerboseFrequency=1, ...
                                  MiniBatchSize=trainParams.Minibatch, ...
                                  ExecutionEnvironment='gpu', ...
                                  Plots="training-progress", ...
                                  Metrics="accuracy", ...
                                  ValidationData=combinedVal, ...
                                  ValidationFrequency=30, ...
                                  Shuffle='every-epoch' ...
        );

        save(fullfile(fldrArgs.OutputFolder, sprintf("debug-%s.mat", trainParams.Parameters)));
        [netTrained, ~] = trainnet(combinedTrain, unetNetwork, lossFcn, options); % train
        currentfig = findall(groot, 'Tag', 'DEEPMONITOR_UIFIGURE'); % grab figure
        exportgraphics(currentfig, fullfile(fldrArgs.OutputFolder, "trainloss.png"));
        save(modelFile, 'netTrained');
    end
    
    fprintf("Network Training Finished At: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));
end
