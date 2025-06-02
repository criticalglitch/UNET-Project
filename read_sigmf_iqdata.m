function [channels, sample_rate, points] = read_sigmf_iqdata(sigmf_filepath) % define
    script = "utilities\\sigmf_import.py";
    python_vars = ["c", "sr", "num", "reals", "imags"];
    
    if size(sigmf_filepath, 1) ~= 1
        file = strjoin(sigmf_filepath, '');
    else
        file = sigmf_filepath;
    end

    [c, sr, num, r_array, i_array] = pyrunfile(script, python_vars, file_to_read = file);

    channels = double(c);
    sample_rate = double(sr);

    num_points = int32(num);

    reals = double(r_array);
    imags = double(i_array);

    if num_points ~= size(reals)
        error("Matlab did not receive the correct number of real points from Python!");
    end

    if num_points ~= size(imags)
        error("Matlab did not receive the correct number of imaginary points from Python!");
    end

    points = reals + (imags * 1i);
end