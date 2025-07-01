function Y = imnorm(X)
    d = im2double(X);
    Y = d ./ sum(d, 3);
end
