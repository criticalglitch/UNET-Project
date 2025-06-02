function iqData = read_rfchallenge_multisensor_frame(basePath, length, set, alpha, frame)
    path = [basePath "\rfChallenge_multisensor_frameLen_" length "\setIndex_" set "\input_frameLen_" length "_setIndex_" set "_alphaIndex_" alpha "_frame" frame ".iqdata"];
    iqData = read_binary_iqdata(path);
end