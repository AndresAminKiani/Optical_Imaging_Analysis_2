% Load the Image
Img = double(I(:, :, 925));

% Estimate the background using a morphological opening operation
background = imopen(Img, strel('disk', 15));

% Subtract the background from the original image
img_bg_subtracted = Img - background;
img_bg_subtracted = max(img_bg_subtracted, 0);

% Enhance contrast using adaptive histogram equalization
enhanced_img = adapthisteq(img_bg_subtracted / max(img_bg_subtracted(:)), 'NumTiles', [8 8], 'ClipLimit', 0.05);

% Apply a Gaussian filter to smooth the image and reduce noise
gaussian_filtered_img = imgaussfilt(enhanced_img, 7);

% Detect edges using the Canny method
edges = edge(gaussian_filtered_img, 'Canny');

% Apply dilation followed by erosion (closing) to strengthen and clean edges
se = strel('disk', 1); % Structuring element
edges_dilated = imdilate(edges, se);
edges_cleaned = imerode(edges_dilated, se);

% Superimpose the cleaned edges on the original image
superimposed_img = Img;
superimposed_img(edges_cleaned) = max(Img(:)); % Highlight edges

% Display the superimposed image
figure;
imshow(superimposed_img, []);
title('Superimposed Edges on Original Image');

% Perform Hough Transform to detect linear edges
[H, T, R] = hough(edges_cleaned);
P = houghpeaks(H, 15, 'threshold', ceil(0.3 * max(H(:))));
lines = houghlines(edges_cleaned, T, R, P, 'FillGap', 5, 'MinLength', 20);

% Create an image to display the detected lines with negative slope in the fourth quadrant
linear_edges = zeros(size(edges_cleaned));
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    slope = (xy(2,2) - xy(1,2)) / (xy(2,1) - xy(1,1));
    midpoint = [(xy(1,1) + xy(2,1)) / 2, (xy(1,2) + xy(2,2)) / 2];
    
    % Check for negative slope and if the midpoint is in the fourth quadrant
    if slope < 0 && midpoint(1) > size(Img, 2) / 2 && midpoint(2) > size(Img, 1) / 2
        % Draw the line on the binary image
        linear_edges = insertShape(linear_edges, 'Line', [xy(1,1), xy(1,2), xy(2,1), xy(2,2)], 'Color', 'white', 'LineWidth', 2);
    end
end

% Convert the linear_edges to binary image
linear_edges = im2bw(linear_edges, 0.5);

% Display the detected linear edges with negative slope in the fourth quadrant
figure;
imshow(linear_edges, []);
title('Detected Linear Edges with Negative Slope in Fourth Quadrant');

% Amplify the detected linear edges in the original image
amplified_img = Img;
amplified_img(linear_edges > 0) = max(Img(:));

% Display the amplified image
figure;
imshow(amplified_img, []);
title('Amplified Linear Features in Original Image (Negative Slope in Fourth Quadrant)');
