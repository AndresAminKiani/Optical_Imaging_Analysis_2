function plot_average_fft(Img, titleStr)
    % plot_average_fft computes and plots the average spatial FFT of an image.
    % Img - Input image.
    % titleStr - Title for the plot.

    % Convert the image to double precision
    Img = double(Img);

    % Perform the FFT of the image
    F = fft2(Img);

    % Shift the zero-frequency component to the center
    Fshift = fftshift(F);

    % Compute the magnitude spectrum
    magnitudeSpectrum = abs(Fshift);

    % Compute the average magnitude spectrum
    avgMagnitude = mean(magnitudeSpectrum(:));

    % Plot the magnitude spectrum
  
    subplot(1, 2, 1)
    imagesc(log(1 + magnitudeSpectrum)); % Use logarithmic scale for better visualization
    colormap('jet');
    colorbar;
    title(['Magnitude Spectrum: ', titleStr]);

    % Plot the average magnitude
  subplot(1, 2, 2)
    plot(log(1 + avgMagnitude), 'LineWidth', 2);
    title(['Average Magnitude Spectrum: ', titleStr]);
    xlabel('Frequency');
    ylabel('Magnitude (log scale)');
    grid on;
end
