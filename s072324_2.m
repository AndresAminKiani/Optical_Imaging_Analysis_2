cd /home/range1-raid2/sgwarren-data/Deviant/Kananga/Data/Deviant/K
off_raw = load('DeviantOff.mat');
cd ~/matlab/OpticalImagingProject/VersionControlled

%%
I = off_raw.I;
T = off_raw.T;c
Img = I(:, :, 1);

%%
figure, 
imagesc(Img)

%%
n = length(I);
random_integers = randperm(n);

figure, 
for j = 1 : 16
    Img = I(:, :, random_integers(j));
    subplot(4, 4, j)
    imagesc(Img)
    title(['Title: ', random_integers(j)])
end

%%
n = length(I);
random_integers = randperm(n);

figure, 
for j = 1 : 16
    Img = I(:, :, random_integers(j));
    subplot(4, 4, j)
    imagesc(Img, [2e4 6e4])
    title(['Index: ', num2str(random_integers(j))])
    xlim([30 300])
    ylim([50 300])
end
sgtitle('I(:, :, index)')

% figure, 
% for j = 1 : 16
%     Img = I(:, :, random_integers(j));
%     subplot(4, 4, j)
%     histogram(Img(:))
%     title(['Index: ', num2str(random_integers(j))])
% end
% sgtitle('I(:, :, index)')
% colorbar
% k = 1;
k = 1;
figure, 
for j = 1 : 16
    Img = I(:, :, random_integers(j));
    subplot(4, 4, j)
    try 
        x(:, :, k) = extractVein_1(Img);
        k = k + 1;
        title(['Index: ', num2str(random_integers(j))])
    catch ME
        continue
    end

end
sgtitle('I(:, :, index)')

%%
figure, 
imagesc(nanmean(x, 3))

%%
Img = I(:, :, 52505) + I(:, :, 63512) - I(:, :, 73522) ;

figure, 
imagesc(Img)

%%
Img = double(I(:, :, 925));
% Estimate the background using a morphological opening operation
background = imopen(Img, strel('disk', 15));

% Subtract the background from the original image
img_bg_subtracted = Img - background;

img_bg_subtracted = max(img_bg_subtracted, 0);

enhanced_img = adapthisteq(img_bg_subtracted / max(img_bg_subtracted(:)), 'NumTiles', [8 8], 'ClipLimit', 0.05);

gaussian_filtered_img = imgaussfilt(enhanced_img, 7);
edges = edge(gaussian_filtered_img, 'Canny');

% figure;
% imshow(edges);
% title('Edge Detected Image');

% Apply dilation followed by erosion (closing) to strengthen and clean edges
se = strel('disk', 1); % Structuring element
edges_dilated = imdilate(edges, se);
edges_cleaned = imerode(edges_dilated, se);

% % Display the cleaned edges
% figure;
% imshow(edges_cleaned);
% title('Cleaned Edge Detected Image');

% Superimpose the cleaned edges on the original image
superimposed_img = Img;
superimposed_img(edges_cleaned) = max(Img(:)); % Highlight edges

% Display the superimposed image
figure;
imshow(superimposed_img, []);
title('Superimposed Edges on Original Image');

%
% Perform Hough Transform to detect linear edges
[H, T, R] = hough(edges_cleaned);
P = houghpeaks(H, 15, 'threshold', ceil(0.3 * max(H(:))));
lines = houghlines(edges_cleaned, T, R, P, 'FillGap', 5, 'MinLength', 20);

% Create an image to display the detected lines
linear_edges = zeros(size(edges_cleaned));
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    linear_edges = insertShape(linear_edges, 'Line', [xy(1,1), xy(1,2), xy(2,1), xy(2,2)], 'Color', 'white', 'LineWidth', 2);
end
linear_edges = rgb2gray(linear_edges); % Convert to grayscale

% Display the detected linear edges
figure;
imshow(linear_edges, []);
title('Detected Linear Edges');

% Amplify the detected linear edges in the original image
amplified_img = Img;
amplified_img(linear_edges > 0) = max(Img(:));
% Display the amplified image
figure;
imshow(amplified_img, []);
title('Amplified Linear Features in Original Image');

