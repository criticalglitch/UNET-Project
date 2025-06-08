function folders = get_image_folders(basePath, destination)
    basefmt = '%s\\single_channel_dataset\\sep_train\\%s\\';
    
    sigmfCommsPath = sprintf(basefmt, basePath, 'CommSignal3');
    sigmfEMPath    = sprintf(basefmt, basePath, 'EMISignal1');
    sigmfComm3CompPath  = sprintf(basefmt, basePath, 'Components\CommSignal3\Comm2');
    sigmfComm3InferPath = sprintf(basefmt, basePath, 'Components\CommSignal3\Interference');
    sigmfEM1CompPath  = sprintf(basefmt, basePath, 'Components\EMISignal1\Comm2');
    sigmfEM1InferPath = sprintf(basefmt, basePath, 'Components\EMISignal1\Interference');
    
    pathfmt = 'Images\\%s\\%s\\';

    folderCommsPath = sprintf(pathfmt, destination, 'CommSignal3');
    folderEMPath    = sprintf(pathfmt, destination, 'EMISignal1');
    folderComm3CompPath  = sprintf(pathfmt, destination, 'Components\CommSignal3\Comm2');
    folderComm3InferPath = sprintf(pathfmt, destination, 'Components\CommSignal3\Interference');
    folderEM1CompPath  = sprintf(pathfmt, destination, 'Components\EMISignal1\Comm2');
    folderEM1InferPath = sprintf(pathfmt, destination, 'Components\EMISignal1\Interference');

    folders = [
        struct("imgPath", folderCommsPath, "dataPath", sigmfCommsPath); 
        struct("imgPath", folderEMPath,    "dataPath", sigmfEMPath); 
        struct("imgPath", folderComm3CompPath,  "dataPath", sigmfComm3CompPath); 
        struct("imgPath", folderComm3InferPath, "dataPath", sigmfComm3InferPath);
        struct("imgPath", folderEM1CompPath,  "dataPath", sigmfEM1CompPath); 
        struct("imgPath", folderEM1InferPath, "dataPath", sigmfEM1InferPath);
    ];
end