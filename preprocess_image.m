function smoothed_image = preprocess_image(image, method)
    switch method
        case 'gaussian'
            % Apply Gaussian smoothing
            smoothed_image = imgaussfilt(image, 2); % Adjust the sigma value as needed
        case 'median'
            % Apply median filtering
            smoothed_image = medfilt2(image, [3 3]); % Adjust the filter size as needed
        otherwise
            error('Unknown preprocessing method');
    end
end
