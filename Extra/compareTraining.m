netTrained = load("..\UNet-adam-0.010000-1-4\trainnet-adam-0.010000-1-4.mat");
imageSize = [ 720 960 ];
classNames = [ "Signal", "Noise" ];

model = netTrained.netTrained;

cm = [ 0 0 1 ;
       1 0 0 ];

toCheck = "..\Images\Training\CommSignal3\CommSignal2_vs_CommSignal3_sep_train_0000.sigmf-meta.png";
icaFile = "..\Images\GroundTruth\CommSignal3\CommSignal2_vs_CommSignal3_sep_train_0000.sigmf-meta.png";

img = imread(toCheck);
img = imresize(img, 'OutputSize', imageSize);
d = dlarray(single(img), 'SSCB');
output = predict(model, d, InputDataFormats='SSCB');

prob = extractdata(output(:, :, 1));
sig = prob >= 0.5;
sigClass = 2 - sig;

overlaid = labeloverlay(img, categorical(sigClass, 1:length(classNames), classNames), Transparency=0.5, Colormap=cm);

% icaImg = imread(icaFile);
% 
% tiles = {img, icaImg, overlaid};
% 
% combined = imtile(tiles);

figure;
image(overlaid);
