function folders = get_image_folders(basePath, destination)
    basefmt = '%s\\single_channel_dataset\\sep_train\\%s\\';
    
    sigmfCommsPath = sprintf(basefmt, basePath, 'CommSignal3');
    sigmfEMPath    = sprintf(basefmt, basePath, 'EMISignal1');
    sigmfCompPath  = sprintf(basefmt, basePath, 'Components\CommSignal3\Comm2');
    sigmfInferPath = sprintf(basefmt, basePath, 'Components\CommSignal3\Interference');
    
    pathfmt = 'Images\\%s\\%s\\';

    folderCommsPath = sprintf(pathfmt, destination, 'Comms2');
    folderEMPath    = sprintf(pathfmt, destination, 'EM1');
    folderCompPath  = sprintf(pathfmt, destination, 'Components\CommSignal3\Comm2');
    folderInferPath = sprintf(pathfmt, destination, 'Components\CommSignal3\Interference');

    folders = [
        struct("imgPath", folderCommsPath, "dataPath", sigmfCommsPath); 
        struct("imgPath", folderEMPath,    "dataPath", sigmfEMPath); 
        struct("imgPath", folderCompPath,  "dataPath", sigmfCompPath); 
        struct("imgPath", folderInferPath, "dataPath", sigmfInferPath)
    ];
end