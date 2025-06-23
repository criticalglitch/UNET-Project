function iqData = read_binary_iqdata(filePath)
    arguments(Input)
        filePath (1, 1) {mustBeTextScalar}
    end
    arguments(Output)
        iqData (1, :)
    end
    fid = fopen(strjoin(filePath, ''), "rb"); % C flags "read binary"
    if fid == -1
        error(['Unable to open file "' filePath '"' ]);
    end

    cleaner = onCleanup(@() fclose(fid));
    
    try
        fullData = fread(fid, inf, "float32", 0, "l"); % file id, amount of data, format, skip bytes, little endian
    catch
        error(['Unable to read data from file "' filePath '"']);
    end

    iqData = fullData(1:2:end) + (1i * fullData(2:2:end)); % start position, skip, end position
end