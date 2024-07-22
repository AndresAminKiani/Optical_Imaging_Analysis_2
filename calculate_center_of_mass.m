function [cx, cy] = calculate_center_of_mass(image)
    % Calculate the center of mass of a grayscale image
    image(isnan(image)) = 0;
    [rows, cols] = size(image);
    [X, Y] = meshgrid(1:cols, 1:rows);
    
    % Calculate the weighted sum of coordinates
    total_mass = nansum(image(:));
    cx = sum(X(:) .* double(image(:))) / total_mass;
    cy = sum(Y(:) .* double(image(:))) / total_mass;
end
