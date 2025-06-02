function carrierFreq = carrier_frequency(data, sampleRate)
    sampleCount = length(data);
    scale = sampleCount / sampleRate;
    scalePerEntry = scale * 1:sampleCount;
    frequencies = abs(fft(data));
    carrierFreq = mean(scalePerEntry * frequencies');
end