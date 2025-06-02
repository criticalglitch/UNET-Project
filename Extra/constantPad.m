classdef constantPad < nnet.layer.Layer & nnet.layer.Acceleratable
    properties
        PadSize
        PadValue
    end

    methods
        function layer = constantPad(padSize, padValue)
            layer.Name = 'ConstantPad';
            layer.PadSize = padSize;
            layer.PadValue = padValue;
        end

        function Y = predict(layer, X)
            arraySizes = size(X);
            padSize = layer.PadSize;
            newArraySizes = padSize * 2 + arraySizes;
            Y = layer.PadValue * ones(newArraySizes, 'like', dlarray);
            Y((padSize + 1):(end - padSize), (padSize + 1):(end - padSize)) = X;
        end
    end
end
