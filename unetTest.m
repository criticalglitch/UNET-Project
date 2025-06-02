clearvars; clc; close('all');
imdsTrain = imageDatastore("D:\DoctoralWork\AirForceStudy\Images\Training", IncludeSubfolders=true, LabelSource="foldernames"); % create the training image datastore for the spectrograms
imdsTest = imageDatastore("D:\DoctoralWork\AirForceStudy\Images\Evaluation", IncludeSubfolders=true); % load the test data
trainPath = ("D:\DoctoralWork\AirForceStudy\Images\Training"); % location of training set
optim = "adam"; % "sgdm", "rmsprop", "adam", "lbfgs", "lm"
learn_rate = 1e-2; % default = 1e-2
max_epochs = 1;
mini = 6; % minibatch size 
parameters = sprintf("%s-%f-%d-%d", optim, learn_rate, max_epochs, mini);

fldrName = sprintf("UNet-%s", parameters);
if exist(fldrName, "dir") ~= 7
    mkdir(fldrName);
end

function train_network(imdsTrain, trainPath, optim, learn_rate, max_epochs, mini, fldrName, parameters)
    classNames = ["Signal", "Noise"]; % labels
    % pixelLabelIDs = [];
    while hasdata(testresize)
        img = read(testresize);
        simg = single(img);
        % label_value = ica_fastica(simg, 2); 
        % pixelLabelIDs = [pixelLabelIDs, label_value];
    end
    pixelLabelIDs = {[255 255 255], [0 0 0]}; % create an array that maps pixels to classes
    pxds = pixelLabelDatastore(trainPath, classNames, pixelLabelIDs, IncludeSubfolders = true); % pixel label datastore
    imageSize = [720, 960 3]; % 2d array with dimensions of image
    numClasses = 2; % number of classes
    unetNetwork = unet(imageSize, numClasses); % initialize unet
    lossFcn = "index-crossentropy"; % loss function definition (classification: "crossentropy", "index-crossentropy", "binary-crossentropy"), (regression: "mae", "mse", "huber")
    trainresize = transform(imdsTrain, @(x) imresize(x, [720, 960])); % resize images
    combinedTrain = combine(trainresize, pxds); % combine training data with pixel datastore
    options = trainingOptions(optim, InitialLearnRate=learn_rate, MaxEpochs=max_epochs, CheckpointFrequency=1, InputDataFormats='SSCB', ...
    TargetDataFormats='SSCB', VerboseFrequency=1, MiniBatchSize=mini, ExecutionEnvironment='gpu', Plots="training-progress"); 
    % options object 

    % debugging code
    disp(imageSize);
    disp(trainresize);
    disp(options);
    disp(pxds);
    disp(combinedTrain);
    disp(unetNetwork);
    save(sprintf("%s\\debug-%s.mat", fldrName, parameters));
    train_concat = sprintf("%s\\trainnet-%s.mat", fldrName, parameters);
    [netTrained, ~] = trainnet(combinedTrain, unetNetwork, lossFcn, options); % train
    save(train_concat, 'netTrained');
end

function test_data(imdsTest, netTrained, fldrName, parameters)
    testresize = transform(imdsTest, @(x) imresize(x, [720, 960]));
    fileIdx = 0;
    outName = sprintf("%s\\Output", fldrName);
    if exist(outName, "dir") ~= 7
        mkdir(outName);
    end
    while hasdata(testresize)
        img = read(testresize);
        fileIdx = fileIdx + 1;
        simg = single(img);
        d = dlarray(simg, 'SSCB');
        output = predict(netTrained, d, InputDataFormats='SSCB');
        save(sprintf("%s\\output-%s-%04d.mat", outName, parameters, fileIdx), "output");
    end
end

train_concat = sprintf("%s\\trainnet-%s.mat", fldrName, parameters);
if exist(train_concat, 'file') ~= 2
    train_network(imdsTrain, trainPath, optim, learn_rate, max_epochs, mini, fldrName, parameters); % train the neural network and save to disk (only call once per concat)
end
netTrained = load(train_concat);
test_data(imdsTest, netTrained.netTrained, ldrName, parameters); % load the neural network from disk and then test the data