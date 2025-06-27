clearvars; clc; close('all');

fprintf("Script Start: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

trainImagePath = fullfile('Images', 'Training');
testImagePath = fullfile("Images", "Evaluation");
pixelImagePath = fullfile("Images", "GroundTruth");

classNames = [ "Signal", "Noise" ];         % labels
pixelLabelIDs = { [0 0 255], [255 0 0] }; % create an array that maps pixels to classes
imageSize = [ 720 960 ];
class_dim = size(pixelLabelIDs, 2);

optim = "adam"; % "sgdm", "rmsprop", "adam", "lbfgs", "lm"
learn_rate = 1e-2; % default = 1e-2
max_epochs = 1;
mini = 4; % minibatch size
parameters = sprintf("%s-%f-%d-%d", optim, learn_rate, max_epochs, mini);

function classes = componentMatrixToClasses(componentMatrix)
    [ ~, classes ] = max(componentMatrix, [], 3);
end

fldrName = sprintf("UNet-%s", parameters);
if exist(fldrName, "dir") ~= 7
    mkdir(fldrName);
end

generate_test_images(testImagePath, imageSize);
generate_training_images(imageSize);
generate_pixel_labels(trainImagePath, pixelImagePath, pixelLabelIDs, imageSize, @componentMatrixToClasses);
% generate_evaluation_truth(); % TODO: Pass in necessary parameters
train_concat = sprintf("trainnet-%s.mat", parameters);
fldrArgs = struct("TrainImages", trainImagePath, ...
                    "LabelImages", pixelImagePath, ...
                    "OutputFolder", fldrName, ...
                    "ModelFile", train_concat);
trainParams = struct("Optimizer", optim, ...
                    "LearnRate", learn_rate, ...
                    "MaxEpochs", max_epochs, ...
                    "Minibatch", mini, ...
                    "Parameters", parameters);
train_network(fldrArgs, imageSize, classNames, pixelLabelIDs, trainParams); % train the neural network and save to disk (only call once per concat)

netTrained = load(fullfile(fldrName, train_concat));
test_network(testImagePath, imageSize, netTrained.netTrained, fldrName, parameters); % load the neural network from disk and then test the data
gen_predictive_img(testImagePath, parameters, imageSize, classNames);
