function [imdsTrain, imdsVal, pxdsTrain, pxdsVal] = partition_semantic_segmentation_data(imds, pxds, train_amount)
% Partition CamVid data by randomly selecting 60% of the data for training. The
% rest is used for testing.
    
% Set initial random state for example reproducibility.
rng(0); 
numFiles = numpartitions(imds);
shuffledIndices = randperm(numFiles);

% Use train_amount% of the images for training.
numTrain = round(train_amount * numFiles);
trainingIdx = shuffledIndices(1:numTrain);

% Use the remaining images for validation
valIdx = shuffledIndices(numTrain+1:end);

% Create image datastores for training and test.
imdsTrain = subset(imds,trainingIdx);
imdsVal = subset(imds,valIdx);

% Create pixel label datastores for training and test.
pxdsTrain = subset(pxds,trainingIdx);
pxdsVal = subset(pxds,valIdx);
end