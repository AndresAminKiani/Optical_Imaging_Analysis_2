function Img_morph = morphological_operations(Img, se)
    % morphological_operations applies morphological operations to an image.
    % Img - Input image.
    % se - Structuring element for the morphological operation.

    % Convert the image to double precision
    Img = double(Img);

    % Apply morphological operations (dilation followed by erosion)
    Img_dilated = imdilate(Img, se);
    Img_morph = imerode(Img_dilated, se);
end
