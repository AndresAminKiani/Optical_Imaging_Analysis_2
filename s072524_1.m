cd /home/range1-raid2/sgwarren-data/Deviant/Kananga/Data/Deviant/K
off_raw = load('DeviantOff.mat');
cd ~/matlab/OpticalImagingProject/VersionControlled

%%
I = off_raw.I;

%%
numImages = 16;

% Randomly select numImages indices
randomIndices = randperm(size(I, 3), numImages);

% Create a figure
figure;

% Loop through each selected image and display it in a subplot
for i = 1:numImages
    % Select the image at the random index
    img = I(:, :, randomIndices(i));
    
    % Create a subplot
    subplot(ceil(sqrt(numImages)), ceil(sqrt(numImages)), i);
    
    % Display the image
%     imshow(img, []);
        imagesc(img);

    % Add a title with the image index
    title(sprintf('Image %d', randomIndices(i)));
end

%%
% Assume I is your 316x316x116119 image matrix
% Specify the index of the image you want to grab
imageIndex = 62911; % Replace this with the desired index

% Extract the specific image
selectedImage = I(:, :, imageIndex);

% Display the selected image
figure;
% imshow(selectedImage, []);
imagesc(selectedImage);
title(sprintf('Image %d', imageIndex));

%%
% r 307 c 172 r 307 92 259 292 = 90 to 310 rows 170 to 300 col
figure, 
imagesc(selectedImage(80 : 315, 150 : 280))

%%
% Assume I is your 316x316x116119 image matrix
% Specify the reference image index
referenceIndex = 62911;

% Extract the reference image
referenceImage = I(:, :, referenceIndex);

% Define the region R in the 4th quadrant
R = referenceImage(80:315, 150:280);

% Define the ranges for sliding and rotation
slideRange = -30:30; % Horizontal and vertical slide range
rotationRange = -3:3; % Rotation range

% Number of images to process
numImages = 50;

% Randomly select 100 image indices (excluding the reference image)
imageIndices = randperm(size(I, 3), numImages);

%%
% Assume I is your 316x316x116119 image matrix
% Specify the reference image index
referenceIndex = 62911;

% Extract the reference image and convert to double
referenceImage = double(I(:, :, referenceIndex));

% Define the region R in the 4th quadrant
R = referenceImage(80:315, 150:280);

% Define the ranges for sliding and rotation
slideRange = -30:30; % Horizontal and vertical slide range
rotationRange = -3:3; % Rotation range

% Number of images to process
numImages = 15;

% Randomly select 100 image indices (excluding the reference image)
imageIndices = randperm(size(I, 3), numImages);

% Initialize a structure array to store the best correlation and parameters for each image
bestAlignments(numImages) = struct('imageIndex', [], 'bestCorrelation', -inf, 'slideX', [], 'slideY', [], 'rotation', []);

% Initialize a counter for valid images
validImageCounter = 0;

% Loop through each selected image
for i = 1:numImages
    % Select the image at the random index and convert to double
    imgIndex = imageIndices(i);
    img = double(I(:, :, imgIndex));

    % Skip the image if it is all NaNs, all zeros, or too uniform
    if all(isnan(img(:))) || all(img(:) == 0) || std(img(:)) < 1e-3
        continue;
    end

    % Increment the valid image counter
    validImageCounter = validImageCounter + 1;

    % Initialize the best correlation for the current image
    bestCorrelation = -inf;
    bestParams = struct('slideX', [], 'slideY', [], 'rotation', []);

    % Loop through sliding and rotation ranges
    for slideX = slideRange
        for slideY = slideRange
            for rotation = rotationRange
                % Rotate the region R
                rotatedR = imrotate(R, rotation, 'bilinear', 'crop');

                % Define the region of interest in the current image
                roi = img(max(1, 80 + slideY):min(316, 315 + slideY), ...
                          max(1, 150 + slideX):min(280, 280 + slideX));

                % Ensure the sizes match before correlation
                [rRows, rCols] = size(rotatedR);
                [roiRows, roiCols] = size(roi);

                if rRows == roiRows && rCols == roiCols
                    % Calculate the correlation
                    corrValue = corr2(rotatedR, roi);

                    % Update the best correlation and parameters if needed
                    if corrValue > bestCorrelation
                        bestCorrelation = corrValue;
                        bestParams.slideX = slideX;
                        bestParams.slideY = slideY;
                        bestParams.rotation = rotation;
                    end
                end
            end
        end
        display([num2str(i), ' ', num2str(slideX)])
    end

    % Store the best correlation and parameters for the current image
    bestAlignments(validImageCounter).imageIndex = imgIndex;
    bestAlignments(validImageCounter).bestCorrelation = bestCorrelation;
    bestAlignments(validImageCounter).slideX = bestParams.slideX;
    bestAlignments(validImageCounter).slideY = bestParams.slideY;
    bestAlignments(validImageCounter).rotation = bestParams.rotation;
end

% Display the best alignments for each valid image
for i = 1:validImageCounter
    fprintf('Image Index: %d\n', bestAlignments(i).imageIndex);
    fprintf('Best Correlation: %.4f\n', bestAlignments(i).bestCorrelation);
    fprintf('Slide X: %d\n', bestAlignments(i).slideX);
    fprintf('Slide Y: %d\n', bestAlignments(i).slideY);
    fprintf('Rotation: %d\n', bestAlignments(i).rotation);
    fprintf('---------------------\n');
end

%%

% Assume I is your 316x316x116119 image matrix
% Initialize an empty array to store aligned images
alignedImages = [];

% Loop through the best alignments to align the images
for i = 1:length(bestAlignments)
    imgIndex = bestAlignments(i).imageIndex;
    slideX = bestAlignments(i).slideX;
    slideY = bestAlignments(i).slideY;
    rotation = bestAlignments(i).rotation;
    
    if isempty(imgIndex)
        continue;
    end

    % Extract and convert the image to double
    img = double(I(:, :, imgIndex));

    % Rotate the entire image by the specified rotation
    rotatedImg = imrotate(img, rotation, 'bilinear', 'crop');

    % Define the translation for the entire image
    translatedImg = zeros(size(rotatedImg));
    xStart = max(1, 1 + slideX);
    yStart = max(1, 1 + slideY);
    xEnd = min(size(rotatedImg, 1), size(rotatedImg, 1) + slideX);
    yEnd = min(size(rotatedImg, 2), size(rotatedImg, 2) + slideY);

    xOffset = max(1, 1 - slideX);
    yOffset = max(1, 1 - slideY);

    translatedImg(xStart:xEnd, yStart:yEnd) = rotatedImg(xOffset:xOffset+(xEnd-xStart), yOffset:yOffset+(yEnd-yStart));

    % Store the aligned image in the alignedImages matrix
    alignedImages = cat(3, alignedImages, translatedImg);
    i
end

% alignedImages now contains the aligned images of size 316x316xK

%%
figure, 
x = nanmean(alignedImages, 3);

%%
figure, 
subplot(1, 2, 1)
imagesc(nanmean(I, 3))
title('Pre Alignment (n = 100)')

subplot(1, 2, 2)
imagesc(nanmean(alignedImages, 3))
title('Post Alignment (n = 100)')