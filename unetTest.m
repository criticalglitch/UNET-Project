clearvars; clc; close('all');

fprintf("Script Start: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

basePath = 'D:\DoctoralWork';
if exist(basePath, "dir") ~= 7
  basePath = '~/Documents/GitHub/UNET-Project';
end
trainImagePath = "Images\Training";
testImagePath = "Images\Evaluation"; 
pixelImagePath = "Images\GroundTruth";

classNames = ["Signal", "Noise"];         % labels
imageSize = [ 720 960 ];

optim = "adam"; % "sgdm", "rmsprop", "adam", "lbfgs", "lm"
learn_rate = 1e-2; % default = 1e-2
max_epochs = 1;
mini = 6; % minibatch size 
parameters = sprintf("%s-%f-%d-%d", optim, learn_rate, max_epochs, mini);

fldrName = sprintf("UNet-%s", parameters);
if exist(fldrName, "dir") ~= 7
    mkdir(fldrName);
end
% 
% generate_test_images(basePath, testImagePath);
% generate_training_images(basePath);
% 
% files = dir(strjoin([pixelImagePath "\**\*.png"], ''));
% if isempty(files)
%     generate_pixel_labels(trainImagePath, pixelImagePath, imageSize);
% end
% 
% train_concat = sprintf("%s\\trainnet-%s.mat", fldrName, parameters);
% if exist(train_concat, 'file') ~= 2
%     train_network(trainImagePath, pixelImagePath, imageSize, classNames, optim, learn_rate, max_epochs, mini, fldrName, parameters); % train the neural network and save to disk (only call once per concat)
% end
% netTrained = load(train_concat);
% test_network(testImagePath, imageSize, netTrained.netTrained, fldrName, parameters); % load the neural network from disk and then test the data

gen_predictive_img(testImagePath, parameters, imageSize, classNames);