function [I_t, trans_t] = align_ImgSet(I, ref_image)  
    a = ref_image;
    for j = 1 : size(I, 3)
        b = I(:, :, j);
        [bb, trans] = align_to_maximize_overlap(a, b);
        bb(isnan(bb)) = 0;
        I_t(:, :, j) = bb;
        trans_t(j, :, :) = trans;
        close all
        j
    end
end