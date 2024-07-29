function Img_adaptive = adaptive_thresholding(Img, windowSize, C)
    % adaptive_thresholding applies adaptive thresholding to an image.
    % Img - Input image.
    % windowSize - Size of the local region.
    % C - Constant subtracted from the mean.

    % Convert the image to double precision
    Img = double(Img);

    % Apply adaptive thresholding
    Img_adaptive = adaptthresh(Img, 'NeighborhoodSize', windowSize, 'ForegroundPolarity', 'bright', 'Statistic', 'mean');
    Img_adaptive = imbinarize(Img, Img_adaptive - C);
end
