function gray_image = convert_to_grayscale(image)
    % Convert image to grayscale if it is not already
    if size(image, 3) == 3
        gray_image = rgb2gray(image);
    else
        gray_image = image;
    end
end
