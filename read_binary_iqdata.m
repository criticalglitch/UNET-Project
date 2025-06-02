function iqData = read_binary_iqdata(filePath)
    fid = fopen(strjoin(filePath, ''), "rb");
    if fid == -1
        error(['Unable to open file "' filePath '"' ]);
    end

    cleaner = onCleanup(@() fclose(fid));
    
    try
        fullData = fread(fid, inf, "float32", 0, "l");
    catch
        error(['Unable to read data from file "' filePath '"']);
    end

    iqData = fullData(1:2:end) + (1i * fullData(2:2:end));
end