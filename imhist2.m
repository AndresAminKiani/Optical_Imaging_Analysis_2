function h = imhist2(I1, I2, nbins)
    if nargin < 3
        nbins = 256;
    end

    I1 = double(I1);
    I2 = double(I2);

    % Normalize images to the range [0, nbins-1]
    I1 = round((nbins - 1) * (I1 - min(I1(:))) / (max(I1(:)) - min(I1(:))));
    I2 = round((nbins - 1) * (I2 - min(I2(:))) / (max(I2(:)) - min(I2(:))));

    h = accumarray([I1(:) + 1, I2(:) + 1], 1, [nbins nbins]);
end
