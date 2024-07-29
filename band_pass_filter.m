function Img_band = band_pass_filter(Img, D0_low, D0_high)
    % band_pass_filter applies a band-pass filter to an image.
    % Img - Input image.
    % D0_low - Low cutoff frequency for the high-pass filter.
    % D0_high - High cutoff frequency for the low-pass filter.

    % Convert the image to double precision
    Img = double(Img);

    % Get the size of the image
    [rows, cols] = size(Img);

    % Create the low-pass filter
    u = 0:(rows-1);
    v = 0:(cols-1);
    idx = find(u > rows/2);
    u(idx) = u(idx) - rows;
    idy = find(v > cols/2);
    v(idy) = v(idy) - cols;
    [V, U] = meshgrid(v, u);
    D = sqrt(U.^2 + V.^2);
    H_low = exp(-(D.^2) / (2 * (D0_high^2)));

    % Create the high-pass filter
    H_high = 1 - exp(-(D.^2) / (2 * (D0_low^2)));

    % Combine to form the band-pass filter
    H_band = H_low .* H_high;

    % Perform the FFT of the image
    F = fft2(Img);

    % Shift the zero-frequency component to the center
    Fshift = fftshift(F);

    % Apply the band-pass filter to the FFT of the image
    Ffiltered = H_band .* Fshift;

    % Shift the zero-frequency component back
    Ffiltered = ifftshift(Ffiltered);

    % Perform the inverse FFT to get the band-pass filtered image
    Img_band = ifft2(Ffiltered);

    % Take the real part of the filtered image
    Img_band = real(Img_band);
end
