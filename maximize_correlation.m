function [best_params, max_corr] = maximize_correlation(A, B)
    best_params = [0, 0, 0];
    max_corr = -inf;
    
    for x_shift = -5:5
        for y_shift = -5:5
            for angle = -2:2
                % Apply transformation
                tform = affine2d([cosd(angle), -sind(angle), 0;
                                  sind(angle), cosd(angle), 0;
                                  x_shift, y_shift, 1]);
                B_transformed = imwarp(B, tform, 'OutputView', imref2d(size(A)));
                
                % Calculate correlation
                corr_value = corr2(A, B_transformed);
                
                % Update best parameters if correlation is higher
                if corr_value > max_corr
                    max_corr = corr_value;
                    best_params = [x_shift, y_shift, angle];
                end
            end
        end
    end
end
