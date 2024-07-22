function cost = cost_function(params, A, B)
    % Transform image B using affine transformation
    tform = affine2d([cos(params(3)), -sin(params(3)), 0;
                      sin(params(3)), cos(params(3)), 0;
                      params(1), params(2), 1]);
    B_transformed = imwarp(B, tform, 'OutputView', imref2d(size(A)));
    
    % Calculate mutual information
    mi = calculate_mutual_information(A, B_transformed);
    cost = -mi; % Negative because we want to maximize mutual information
end
