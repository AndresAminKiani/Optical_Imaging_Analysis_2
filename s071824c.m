X = Kon_2;

time_windows = [2 : 31];
Ke = X{    4   };
ref_img = nanmean(Ke(:, :, 4, time_windows), 4);

%%
trans_att_in = cell(9, 2);
for n = 1 : 9
time_windows = [2 : 31];
Ke = X{    n   }; % 316 316 139 32
I = nanmean(Ke(:, :, :, time_windows), 4);

% imwarp(b, best_tform, 'OutputView', imref2d(size(a)));
[I_aligned, ref_aligned] = align_ImgSet(I, ref_img);

% Img = nanmean(I_aligned, 3);
% figure, imagesc(Img)
trans_att_in{   n, 1  } = ref_aligned;
trans_att_in{   n, 2  } = I_aligned;
n
end

trans_att_out = cell(9, 2);
time_windows = [2 : 31];

for n = 10 : 18
Ke = X{    n   }; % 316 316 139 32
I = nanmean(Ke(:, :, :, time_windows), 4);

% imwarp(b, best_tform, 'OutputView', imref2d(size(a)));
[I_aligned, ref_aligned] = align_ImgSet(I, ref_img);

% Img = nanmean(I_aligned, 3);
% figure, imagesc(Img)
trans_att_out{   n - 9, 1  } = ref_aligned;
trans_att_out{   n - 9, 2  } = I_aligned;
n
end

%%
figure,
for i = 1   :   9
    current_matrix = trans_att_out{i, 2};
    mean_matrix = mean(current_matrix, 3);
    mean_matrices_out(:, :, i) = mean_matrix;
    mean_matrix(mean_matrix == 0) = nan;
    subplot(3, 3, i)
    imagesc(mean_matrix)
end
sgtitle('Attend Out')

figure,
for i = 1   :   9
    current_matrix = trans_att_in{i, 2};
    mean_matrix = mean(current_matrix, 3);
    mean_matrices_in(:, :, i) = mean_matrix;
    mean_matrix(mean_matrix == 0) = nan;
    subplot(3, 3, i)
    imagesc(mean_matrix)
end
sgtitle('Attend In')

%%
figure, 
subplot(1, 2, 1)
in = mean(mean_matrices_in, 3);
imagesc(in)
title('Attend In')

subplot(1, 2, 2)
out = mean(mean_matrices_out, 3);
imagesc(out)
title('Attend Out')

%%
figure, 
scatter(out(:), in(:))
axis equal
xlim([-1 1])
ylim([-1 1])
