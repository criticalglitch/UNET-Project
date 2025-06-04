loadfile = load("D:\DoctoralWork\UNET Project\UNet-adam-0.010000-1-6\Output\output-adam-0.010000-1-6-0382");

imgs = loadfile.output;

channels = size(imgs, 3);

for c = 1:channels

    img = imgs(:, :, c);

    imshow(img)

end