% Created the pipeline for aligning monkey K images. This script aligns
% the trial-averaged images. The next step is to implement the alignment
% procedure for individual images across trials, effectively processing
% all images in the dataset.
%
% `transform_ds` is an 18-by-2 cell array, where each row corresponds to
% a Gabor location. For example, trial images assigned to position 9
% will have alignment information in row 9 of `transform_ds`. In this
% setup, `transform_ds(9, 1)` contains X transformation instructions,
% where X is the number of trials associated with position 9.
%
% Specifically, `transform_ds{9, 1}` holds an array of X `affine2d` 
% objects. Each element of this array represents the transformation for 
% a trial. For instance, element 5 (or trial 5) of position 9 has an 
% `affine2d` object `transform_ds{9, 1}(5, 1)`, which includes:
% - `.T`: a 3-by-3 matrix
% - `.Dimensionality`: a 1-by-1 double
%
% The `transform_ds` array was created by concatenating `trans_att_in`, 
% which contains transformation information for the 9 attend-in positions,
% and `trans_att_out`, which contains data for the 9 attend-out positions.
% 
% These structures were generated through the following sequence:
% `s071825c.m` > `align_ImgSet.m` > `align_to_maximize_overlap` > 
% `extract_best_transformation.m`, where the best transformation was 
% computed as:
% `best_tform = affine2d(best_translation_matrix * best_rotation_matrix)`,
% and applied using:
% `postAligned_img = imwarp(preAligned_img, best_tform, 'OutputView', outputView);`

% Kon_2 :: 1 - 18 :: {1} ::  316  316  19  31
transform_ds = [trans_att_in; trans_att_out];

%%
tform_list = transform_ds{9, 1}; % 219 x 1

%% 
element = 9; 
    tr = 1; 
        tform = tform_list(tr);
        time = 5;
            I_pre = Kon_2{element}(:, :, tr, time);
            I_post = imwarp(I_pre, tform, 'OutputView', outputView);

%%
for element = 1 : 9
    for tr = 1 : size(Kon_2{element}, 3)
        tform = tform_list(tr);
        for time = 1 : size(Kon_2{element}, 4)
            I_pre = Kon_2{element}(:, :, tr, time);
            I_post = imwarp(I_pre, tform, 'OutputView', outputView);
            I_post_set(:, :, tr, time) = I_post;
            Kon_aligned{element} = I_post_set;
        end
        display(['element: ', num2str(element), 'trials: ', num2str(tr)])
    end
end

%%
II = squeeze(nanmean(nanmean(I_post_set, 3), 4));
II(II == 0) = nan;
