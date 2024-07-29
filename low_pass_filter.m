function Img_low = low_pass_filter(Img, D0)
    % low_pass_filter applies a low-pass filter to an image.
    % Img - Input image.
    % D0 - Cutoff frequency for the low-pass filter.

    % Convert the image to double precision
    Img = double(Img);

    % Get the size of the image
    [rows, cols] = size(Img);

    % Create a low-pass filter
    u = 0:(rows-1);
    v = 0:(cols-1);
    idx = find(u > rows/2);
    u(idx) = u(idx) - rows;
    idy = find(v > cols/2);
    v(idy) = v(idy) - cols;
    [V, U] = meshgrid(v, u);
    D = sqrt(U.^2 + V.^2);
    H = exp(-(D.^2) / (2 * (D0^2)));

    % Perform the FFT of the image
    F = fft2(Img);

    % Shift the zero-frequency component to the center
    Fshift = fftshift(F);

    % Apply the filter to the FFT of the image
    Ffiltered = H .* Fshift;

    % Shift the zero-frequency component back
    Ffiltered = ifftshift(Ffiltered);

    % Perform the inverse FFT to get the filtered image
    Img_low = ifft2(Ffiltered);

    % Take the real part of the filtered image
    Img_low = real(Img_low);
end
