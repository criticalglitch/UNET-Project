function iqData = read_rfchallenge_multisensor_frame(length, set, alpha, frame)
    path = fullfile("Radio Data", "Evaluation", sprintf("input_frameLen_%d_setIndex_%d_alphaIndex_%d_frame%d.iqdata", length, set, alpha, frame));
    iqData = read_binary_iqdata(path);
end