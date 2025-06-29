function unetTest(NameValueArgs)
arguments 
    NameValueArgs.Optimizer (1, 1) {mustBeTextScalar} = "adam" % "sgdm", "rmsprop", "adam", "lbfgs", "lm"
    NameValueArgs.LearnRate (1, 1) {mustBeNumeric} = 1e-3   % Default = 1e-2
    NameValueArgs.MaxEpochs (1, 1) {mustBeGreaterThan(NameValueArgs.MaxEpochs, 0)} = 1      % Number of Epochs to Run
    NameValueArgs.BatchSize (1, 1) {mustBeGreaterThan(NameValueArgs.BatchSize, 0)} = 4      % Minibatch Size
    NameValueArgs.LearnSchedule (1, 1) {mustBeTextScalar} = "piecewise"
    NameValueArgs.LearnDropFactor (1, 1) {mustBePositive} = 0.2
    NameValueArgs.LearnDropPeriod (1, 1) {mustBePositive} = 5
    NameValueArgs.EncoderDepth (1, 1) {mustBePositive} = 4
end

fprintf("Script Start: %s\n", datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'));

trainImagePath = fullfile('Images', 'Training');
testImagePath = fullfile("Images", "Evaluation");
pixelImagePath = fullfile("Images", "GroundTruth");

classNames = [ "Signal", "Noise" ];         % labels
pixelLabelIDs = { [0 0 255], [255 0 0] }; % create an array that maps pixels to classes
imageSize = [ 720 960 ];
class_dim = size(pixelLabelIDs, 2);

function classes = componentMatrixToClasses(componentMatrix)
    [ ~, classes ] = max(componentMatrix, [], 3);
end

parameters = sprintf("%s-%f-%d-%d-%s-%d-%d", ...
                     NameValueArgs.Optimizer, ...
                     NameValueArgs.LearnRate, ...
                     NameValueArgs.MaxEpochs, ...
                     NameValueArgs.BatchSize, ...
                     NameValueArgs.LearnSchedule, ...
                     NameValueArgs.LearnDropFactor, ...
                     NameValueArgs.LearnDropPeriod);
fldrArgs = struct("TrainImages",  trainImagePath, ...
                  "LabelImages",  pixelImagePath, ...
                  "OutputFolder", sprintf("UNet-%s", parameters), ...
                  "ModelFile",    sprintf("trainnet-%s.mat", parameters));

if exist(fldrArgs.OutputFolder, "dir") ~= 7
    mkdir(fldrArgs.OutputFolder);
end

generate_test_images(testImagePath, imageSize);
generate_training_images(imageSize);
generate_pixel_labels(trainImagePath, pixelImagePath, pixelLabelIDs, imageSize, @componentMatrixToClasses);
% generate_evaluation_truth(); % TODO: Pass in necessary parameters

trainParams = struct("Optimizer", NameValueArgs.Optimizer, ...
                     "LearnRate", NameValueArgs.LearnRate, ...
                     "MaxEpochs", NameValueArgs.MaxEpochs, ...
                     "Minibatch", NameValueArgs.BatchSize, ...
                     "LearnSche", NameValueArgs.LearnSchedule, ...
                     "LearnDrop", NameValueArgs.LearnDropFactor, ...
                     "LDropPerd", NameValueArgs.LearnDropPeriod, ...
                     "EncdrDpth", NameValueArgs.EncoderDepth);
train_network(fldrArgs, imageSize, classNames, pixelLabelIDs, trainParams); % train the neural network and save to disk (only call once per concat)

netTrained = load(fullfile(fldrArgs.OutputFolder, fldrArgs.ModelFile));
test_network(testImagePath, imageSize, netTrained.netTrained, fldrArgs.OutputFolder); % load the neural network from disk and then test the data
gen_predictive_img(testImagePath, fldrArgs.OutputFolder, imageSize, classNames);

end
