cd /home/range1-raid2/sgwarren-data/Deviant/Kananga/Data/Deviant/K
off_raw = load('DeviantOff.mat');
cd ~/matlab/OpticalImagingProject/VersionControlled

%%
I = off_raw.I;
T = off_raw.T;
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
colorbar

figure, 
for j = 1 : 16
    Img = I(:, :, random_integers(j));
    subplot(4, 4, j)
    histogram(Img(:))
    title(['Index: ', num2str(random_integers(j))])
end
sgtitle('I(:, :, index)')
colorbar

%%
Img = I(:, :, 52505) + I(:, :, 63512);

%%
figure, 
for j = 1 : 16
    Img = double(I(:, :, random_integers(j))); % Select a random image
%     median_value = median(Img(:));
%     Img(Img < median_value) = nan; % Set pixels below median to NaN
        Img(Img == 0) = NaN;
% Calculate the mean and standard deviation of the non-NaN values
%     non_nan_values = Img(~isnan(Img));
%     mean_value = mean(non_nan_values);
%     std_value = std(non_nan_values);
    mean_value = nanmean(Img(:));
    std_value = nanstd(Img(:));
    if isnan(mean_value)
        continue
    end
% Set the display limits between -1 and 1 standard deviation
    display_min = mean_value - std_value;
    display_max = mean_value + std_value;
    
%     Img(Img > display_max) = 0;
%     Img(Img < display_min) = 0;

    subplot(4, 4, j)

    imagesc(Img, [display_min, display_max]) % Set display limits
    title(['Index: ', num2str(random_integers(j))])
    xlim([30 300])
    ylim([50 300])
    colorbar
end

sgtitle('I(:, :, index)') % Set the super title for the figure

%%
mI = nanmean(I, 3);

%%
DS = double(I(:, :, 1 : 1000));
DS = DS - nanmean(DS, 3);
ids = nanstd(DS, [], 3);
Z = DS./ids;
Z = Z(50:300, 50:300, :);
Z_p = permute(Z, [3 1 2]);
X = reshape(Z_p, [size(Z_p, 1) size(Z_p, 2)*size(Z_p, 3)]);
X(isnan(X)) = 0;
[U, ~, V] = svd(X, "econ");
projScores = U' * X;
S = projScores(1, :);
S = reshape(S, [201 151]);

%%
% Assuming I is a 3D matrix of images
DS = double(I(:, :, 1:1000)); % Convert first 1000 images to double
DS = DS - nanmean(DS, 3); % Subtract the mean across the third dimension
ids = nanstd(DS, [], 3); % Compute the standard deviation across the third dimension
Z = DS ./ ids; % Normalize the dataset
Z = Z(50:300, 50:300, :); % Select the region of interest

% Permute the dimensions of Z for reshaping
Z_p = permute(Z, [3, 1, 2]);

% Reshape Z_p into a 2D matrix
X = reshape(Z_p, [size(Z_p, 1), size(Z_p, 2) * size(Z_p, 3)]);

% Replace NaNs with zeros
X(isnan(X)) = 0;

% Perform Singular Value Decomposition (SVD)
[U, ~, V] = svd(X, 'econ');

% Project scores
projScores = U' * X;

%%  Extract the first component scores
S = projScores(150, :);

% Reshape S to match the dimensions of the original region of interest
S = reshape(S, [size(Z, 1), size(Z, 2)]); % 251 x 251 region

% Display the reshaped scores
imagesc(S);
title('First Principal Component Scores');
colorbar;
