refImage = I(:, :, [1 : 500]);

validImageCounter = 0;
clear ref_img
% Loop through each image in the dataset
for j = 1 : 300
    Img = refImage(:, :, j);
    
    % Call the extractVein_2 function and store the result
    try
        result = extractVein_2(Img);
        
        % Increment the valid image counter
        validImageCounter = validImageCounter + 1;
        
        % Store the result in K
        ref_img(:, :, validImageCounter) = result;
        
        % Display the current image index
        disp(['Processing image: ', num2str(j), ' as valid image number: ', num2str(validImageCounter)]);
    catch
        % If there's an error, skip this image
        disp(['Skipping image: ', num2str(j)]);
    end
end

%%
figure,
imagesc(nanmean(ref_img, 3))

%%
R = nanmean(ref_img, 3);

X = x(:, :, 1 : 3e3);
Y = alignedImages;

% Assume R is your 316x316 reference image, and X and Y are your 316x316x3000 datasets
numImages = size(X, 3);

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