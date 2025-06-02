function dataByAntenna = reshape_per_antenna(iqData, nAntenna) 
    perAntenna = length(iqData) / nAntenna;
    if((perAntenna - fix(perAntenna))~=0)
        error("Cannot reshape, number of samples per antenna is not evenly distributed");
    end

    dataByAntenna = reshape(iqData, perAntenna, nAntenna)';
end