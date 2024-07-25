function [best_transformed_bb, best_tform] = align_to_maximize_overlap(a, b)

% Compute binary masks based on standard deviation
aa = a > 2*nanstd(a(:));
bb = b > 2*nanstd(b(:));

% Define the parameters for translation and rotation
x_translations = [-10, 0, 10]; % Example x translations
y_translations = [-10, 0, 10]; % Example y translations
rotation_angles = [-3, 0, 3]; % Example rotations in degrees

% Initialize a matrix to store the results
results = [];

% Loop over all combinations of translations and rotations
for x_translation = x_translations
    for y_translation = y_translations
        for rotation_angle = rotation_angles
            % Create the translation and rotation transformation matrices
            translation_matrix = [1 0 0; 0 1 0; x_translation y_translation 1];
            rotation_matrix = [cosd(rotation_angle) -sind(rotation_angle) 0; sind(rotation_angle) cosd(rotation_angle) 0; 0 0 1];

            % Combine the translation and rotation into one affine transformation
            tform = affine2d(translation_matrix * rotation_matrix);

            % Apply the transformation to the binary image bb
            outputView = imref2d(size(aa));
            transformed_bb = imwarp(bb, tform, 'OutputView', outputView);

            % Calculate the correlation coefficient (or overlap) between aa and transformed_bb
            overlap = sum(sum(aa & transformed_bb));
            
            % Store the results
            results = [results; x_translation, y_translation, rotation_angle, overlap];
        end
    end
end

% Extract the best transformation parameters and matrix
[best_x_translation, best_y_translation, best_rotation_angle, best_correlation, best_tform] = extract_best_transformation(results);

% Apply the best transformation to the original image b
best_transformed_bb = imwarp(b, best_tform, 'OutputView', imref2d(size(a)));
best_transformed_bb(best_transformed_bb == 0) = nan;
% Display the original and transformed images using imagesc in a 1x3 subplot
figure;
subplot(1, 3, 1), imagesc(a), title('Image A');
subplot(1, 3, 2), imagesc(b), title('Image B');
subplot(1, 3, 3), imagesc(best_transformed_bb), title('Transformed Image B');
colormap gray; % Use grayscale colormap for better visibility

% Display the parameters of the best transformation
disp(['Best transformation parameters (x, y, rotation): (', num2str(best_x_translation), ', ', num2str(best_y_translation), ', ', num2str(best_rotation_angle), ')']);
disp(['Maximized Overlap: ', num2str(best_correlation)]);

end
