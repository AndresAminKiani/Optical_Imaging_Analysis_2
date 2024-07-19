function [best_x_translation, best_y_translation, best_rotation_angle, best_correlation, best_tform] = extract_best_transformation(results)

% Find the index of the maximum overlap
[~, maxIndex] = max(results(:, 4));

% Extract the parameters of the best transformation
best_x_translation = results(maxIndex, 1);
best_y_translation = results(maxIndex, 2);
best_rotation_angle = results(maxIndex, 3);
best_correlation = results(maxIndex, 4);

% Create the transformation matrix for the best result
best_translation_matrix = [1 0 0; 0 1 0; best_x_translation best_y_translation 1];
best_rotation_matrix = [cosd(best_rotation_angle) -sind(best_rotation_angle) 0; sind(best_rotation_angle) cosd(best_rotation_angle) 0; 0 0 1];
best_tform = affine2d(best_translation_matrix * best_rotation_matrix);

end