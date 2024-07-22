function output = dftregistration(buf1ft, buf2ft, usfac)
    % Function to register two images using the method of cross-correlation
    % followed by phase correlation to refine the registration
    
    % Compute cross-correlation and find the peak
    CC = ifft2(buf1ft .* conj(buf2ft));
    [max1, loc1] = max(CC(:));
    [loc1(2), loc1(1)] = ind2sub(size(CC), loc1);
    
    % Use the peak to compute the initial estimate of the translation
    [nr, nc] = size(CC);
    row_shift = mod(loc1(1) - 1 + nc/2, nc) - nc/2;
    col_shift = mod(loc1(2) - 1 + nr/2, nr) - nr/2;
    
    % Refine the translation estimate using the phase correlation method
    if usfac > 0
        CC = ifft2(fft2(buf1ft) .* conj(fft2(buf2ft)));
        CCabs = abs(CC);
        [max2, loc2] = max(CCabs(:));
        [loc2(2), loc2(1)] = ind2sub(size(CCabs), loc2);
        row_shift = row_shift + (loc2(1) - size(CC, 1)/2 - 1);
        col_shift = col_shift + (loc2(2) - size(CC, 2)/2 - 1);
    end
    
    % Output the shifts
    output = [1, 1, row_shift, col_shift];
end
