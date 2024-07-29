function Img_unsharp = unsharp_masking(Img, alpha)
    % unsharp_masking applies unsharp masking to an image.
    % Img - Input image.
    % alpha - Scaling factor for the high-pass filtered image.

    % Convert the image to double precision
    Img = double(Img);

    % Create the high-pass filter (using a Gaussian low-pass filter)
    h = fspecial('gaussian', [5 5], 2);
    Img_low = imfilter(Img, h, 'replicate');

    % Subtract the low-pass filtered image from the original image
    Img_high = Img - Img_low;

    % Add the scaled high-pass image back to the original image
    Img_unsharp = Img + alpha * Img_high;
end
