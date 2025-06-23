function iqData = read_rfchallenge_multisensor_frame(length, set, alpha, frame)
    arguments
        length (1, 1) {mustBePositive, mustBeInteger} % frame length
        set (1, 1) {mustBePositive, mustBeInteger} % set index
        alpha (1, 1) {mustBePositive, mustBeInteger} % alpha index
        frame (1, 1) {mustBePositive, mustBeInteger} % frame file
    end
    path = fullfile("Radio Data", "Evaluation", sprintf("input_frameLen_%d_setIndex_%d_alphaIndex_%d_frame%d.iqdata", length, set, alpha, frame));
    iqData = read_binary_iqdata(path);
end