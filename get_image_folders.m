function folders = get_image_folders(destination)    
    sigmfCommsPath = fullfile('Radio Data', 'Training', 'CommSignal3');
    sigmfEMPath    = fullfile('Radio Data', 'Training', 'EMISignal1');
    sigmfComm3CompPath  = fullfile('Radio Data', 'Training', 'Components', 'CommSignal3', 'Comm2');
    sigmfComm3InferPath = fullfile('Radio Data', 'Training', 'Components', 'CommSignal3', 'Interference');
    sigmfEM1CompPath  = fullfile('Radio Data', 'Training', 'Components', 'EMISignal1', 'Comm2');
    sigmfEM1InferPath = fullfile('Radio Data', 'Training', 'Components', 'EMISignal1', 'Interference');

    folderCommsPath = fullfile("Images", destination, 'CommSignal3');
    folderEMPath    = fullfile("Images", destination, 'EMISignal1');
    folderComm3CompPath  = fullfile("Images", destination, 'Components', 'CommSignal3', 'Comm2');
    folderComm3InferPath = fullfile("Images", destination, 'Components', 'CommSignal3', 'Interference');
    folderEM1CompPath  = fullfile("Images", destination, 'Components', 'EMISignal1', 'Comm2');
    folderEM1InferPath = fullfile("Images", destination, 'Components', 'EMISignal1', 'Interference');

    folders = [
        struct("imgPath", folderCommsPath, "dataPath", sigmfCommsPath); 
        struct("imgPath", folderEMPath,    "dataPath", sigmfEMPath); 
        struct("imgPath", folderComm3CompPath,  "dataPath", sigmfComm3CompPath); 
        struct("imgPath", folderComm3InferPath, "dataPath", sigmfComm3InferPath);
        struct("imgPath", folderEM1CompPath,  "dataPath", sigmfEM1CompPath); 
        struct("imgPath", folderEM1InferPath, "dataPath", sigmfEM1InferPath);
    ];
end