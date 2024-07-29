x = [];

k = 1;
for j = 1 : 1e4
        Img = I(:, :, j);
        try 
            x(:, :, k) = extractVein_1(Img);
            k = k + 1;
        catch
            continue
        end
        k
end

%%
Iset = nanmean(x(:, :, 1 : 100), 3);
figure, 
imagesc(Iset)

%%
% Assume I is your 316x316x116119 image matrix
% Specify the reference image index

% Extract the reference image
referenceImage = double(Iset);

% Define the region R in the 4th quadrant
R = referenceImage(80:315, 150:280);

% Define the ranges for sliding and rotation
slideRange = -5:5; % Horizontal and vertical slide range
rotationRange = 0:0; % Rotation range

% Number of images to process
numImages = 3e3;

% Randomly select 100 image indices (excluding the reference image)
% imageIndices = randperm(size(x, 3), numImages);
imageIndices = 1 : 3e3;
clear bestAlignments
% Initialize a structure array to store the best correlation and parameters for each image
bestAlignments(numImages) = struct('imageIndex', [], 'bestCorrelation', -inf, 'slideX', [], 'slideY', [], 'rotation', []);

% Initialize a counter for valid images
validImageCounter = 0;

% Loop through each selected image
for i = 1:numImages
    % Select the image at the random index and convert to double
    imgIndex = imageIndices(i);
    img = double(x(:, :, imgIndex));

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


% Assume I is your 316x316x116119 image matrix
% Initialize an empty array to store aligned images
alignedImages = [];

% Loop through the best alignments to align the images
for i = 1:3e3
    imgIndex = bestAlignments(i).imageIndex;
    slideX = bestAlignments(i).slideX;
    slideY = bestAlignments(i).slideY;
    rotation = bestAlignments(i).rotation;
    
    if isempty(imgIndex)
        continue;
    end

    % Extract and convert the image to double
    img = double(x(:, :, imgIndex));

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
z = nanmean(alignedImages, 3);

%%
figure, 
subplot(1, 2, 1)
imagesc(nanmean(alignedImages, 3))
title('Pre Alignment (n = 3000)')

subplot(1, 2, 2)
imagesc(nanmean(x(:, :, 1:1e2), 3))
title('Post Alignment (n = 3000)')

%%
X = x(:, :, 1 : 3e3);
Y = alignedImages;

% Assume R is your 316x316 reference image, and X and Y are your 316x316x3000 datasets
numImages = size(X, 3);

% Convert R to double
R = double(referenceImage);

% Initialize arrays to store correlation coefficients
correlationX = zeros(numImages, 1);
correlationY = zeros(numImages, 1);

% Flatten the reference image to a 1D array
R_flat = R(:);

% Calculate the correlation coefficients for each image in X and Y against the reference image R
for i = 1:numImages
    % Extract the images from X and Y and convert to double
    imgX = double(X(:, :, i));
    imgY = double(Y(:, :, i));
    
    % Flatten the images to 1D arrays
    imgX_flat = imgX(:);
    imgY_flat = imgY(:);
    
    % Calculate the correlation coefficients with the reference image R
    correlationX(i) = corr2(R_flat, imgX_flat);
    correlationY(i) = corr2(R_flat, imgY_flat);
    i
end

%% Create the scatter plot
figure;
scatter(correlationX, correlationY);
hold on;

title('Correlation Coefficients with Reference Image');
grid on;

% Optionally, fit a line to the scatter plot for better visualization
fitLine = fit(correlationX, correlationY, 'poly1');
plot(fitLine, correlationX, correlationY);
legend('Image', 'location', 'best')
xlabel('Correlation with Pre-Alignment');
ylabel('Correlation with Post-Alignment');
set(gca, 'FontSize', 15)
hold off;

%%
bestImg = alignedImages(:, :, correlationY > 0.9);

figure,
imagesc(nanmean(bestImg, 3))
