function [A_smoothed, B_smoothed] = preprocess_images(A, B, method)
    switch method
        case 'gaussian'
            % Apply Gaussian smoothing
            A_smoothed = imgaussfilt(A, 2); % Adjust the sigma value as needed
            B_smoothed = imgaussfilt(B, 2);
        case 'median'
            % Apply median filtering
            A_smoothed = medfilt2(A, [3 3]); % Adjust the filter size as needed
            B_smoothed = medfilt2(B, [3 3]);
        otherwise
            error('Unknown preprocessing method');
    end
end
