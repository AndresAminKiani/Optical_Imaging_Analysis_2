function Img_log = laplacian_of_gaussian(Img, sigma)
    % laplacian_of_gaussian applies a Laplacian of Gaussian filter to an image.
    % Img - Input image.
    % sigma - Standard deviation for the Gaussian filter.

    % Convert the image to double precision
    Img = double(Img);

    % Create the Laplacian of Gaussian filter
    h = fspecial('log', [5 5], sigma);

    % Apply the filter to the image
    Img_log = imfilter(Img, h, 'replicate');
end
