% load the model from the file
% plot it with plot()
item = load("UNet-adam-0.010000-1-6\trainnet-adam-0.010000-1-6.mat");
plot(item.netTrained);