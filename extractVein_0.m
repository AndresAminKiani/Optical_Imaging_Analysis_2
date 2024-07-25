function [] = extractVein_0(I)
Img = double(I);

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
% figure;
% imshow(superimposed_img, []);
% title('Superimposed Edges on Original Image');

% Perform Hough Transform to detect linear edges
[H, T, R] = hough(edges_cleaned);
P = houghpeaks(H, 15, 'threshold', ceil(0.3 * max(H(:))));
lines = houghlines(edges_cleaned, T, R, P, 'FillGap', 5, 'MinLength', 20);

% Create an image to display the detected lines excluding vertical and horizontal lines
linear_edges = zeros(size(edges_cleaned));
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    angle = atan2(abs(xy(2,2) - xy(1,2)), abs(xy(2,1) - xy(1,1))) * 180 / pi;
    if angle > 10 && angle < 80 % Exclude near-vertical and near-horizontal lines
        linear_edges = insertShape(linear_edges, 'Line', [xy(1,1), xy(1,2), xy(2,1), xy(2,2)], 'Color', 'white', 'LineWidth', 2);
    end
end
linear_edges = rgb2gray(linear_edges); % Convert to grayscale

% Display the detected linear edges excluding vertical and horizontal lines
% figure;
% imshow(linear_edges, []);
% title('Detected Linear Edges Excluding Vertical/Horizontal');

% Amplify the detected linear edges in the original image
amplified_img = Img;
amplified_img(linear_edges > 0) = max(Img(:));

% Display the amplified image
% figure;
imshow(amplified_img, []);
% title('Amplified Linear Features in Original Image (Excluding Vertical/Horizontal)');
% title(['I Index: ', num2str(m)])
end