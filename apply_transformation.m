function B_aligned = apply_transformation(B, params, ref_size)
    tform_optimized = affine2d([cosd(params(3)), -sind(params(3)), 0;
                                sind(params(3)), cosd(params(3)), 0;
                                params(1), params(2), 1]);
    B_aligned = imwarp(B, tform_optimized, 'OutputView', imref2d(ref_size));
end
