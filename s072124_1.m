% align_ImgSet.m > align_to_maximize_overlap > extract_best_transformation.m
% trans_att_in > I_aligned > align_ImgSet(I, ref_img) > 
%                        I = mean(Ke, 4) > Ke = Kon_2{element}
element = 4;

%% Q1 What does the mean across time look like for Ke trial = 7?
Ke = Kon_2{element};

tr = 7;
I = nanmean(Ke(:, :, tr, :), 4);
figure,
subplot(1, 2, 1)
imagesc(I)
axis off
title('Kon 2')

% Does it look like trans_att_in(:, :, tr)?
x = trans_att_in{element, 2}(:, :, tr);
x(x == 0) = nan;
subplot(1, 2, 2)
imagesc(x)
axis off
title('trans att in')

%% Q2 What does their superposition and correlation look like?
y = I + x;
figure, 
subplot(1, 2, 1)
imagesc(y)
title('Superposition of K _img and translated K_img')
axis off

subplot(1, 2, 2)
scatter(x(:), I(:))
title('Correlation')
xlabel('x')
ylabel('I shift')

%%
x_shift(x_shift == 0) = nan;
y = I + x_shift;
imagesc(y)
scatter(x(:), I(:))

%% Q3 If we translate I =  nanmean(Ke(:, :, tr, :), 4) = Kon_2{element}
% using its hypothesized t_form will we produce x = trans_att_in{element, 2}(:, :, tr);
tform =  trans_att_in{element, 1}(tr);
I_shift = imwarp(I, tform, 'OutputView', outputView);

% figure
% imagesc(I_shift)

x = trans_att_in{element, 2}(:, :, tr);
x(x == 0) = nan;

I_shift(I_shift == 0) = nan;
figure
subplot(1, 2, 1)
imagesc(I_shift)
axis off

subplot(1, 2, 2)
scatter(x(:), I_shift(:))
xlabel('x')
ylabel('I shift')
title('Correlation')

%% Q4 How much correlation degradation with .5 horizontal translation of same image
translation_amount = [0, 1.5]; % Right by 10 pixels, no vertical shift
x(isnan(x)) = 0;
xx = imtranslate(x, translation_amount);
xx(xx == 0) = nan;
x(x == 0) = nan;

figure
subplot(1, 2, 1)
imagesc(x + xx)
axis off

subplot(1, 2, 2)
scatter(x(:), xx(:))
xlabel('x')
ylabel('I shift')
title('Correlation')

%% Q5 Can we reproduce I_shift without I = nanmean(Ke(:, :, tr, :), 4)?
time = 5;
ft = Ke(:, :, tr, time); % 316x316
ft_t = imwarp(ft, tform, 'OutputView', outputView); 

figure, 
subplot(1, 2, 1)
imagesc(ft)
title(['ft, time: ', num2str(time)])
axis off

subplot(1, 2, 2)
imagesc(ft_t)
title(['ft_t, time: ', num2str(time)])
axis off

%%
x = trans_att_in{element, 2}(:, :, tr);
x(x == 0) = nan;

for time = 1 : 31
    ft = Ke(:, :, tr, time); % 316x316
    ft_t(:, :, time) = imwarp(ft, tform, 'OutputView', outputView); 
end
Ft_t = nanmean(ft_t, 3);
Ft_t(Ft_t == 0) = nan;
figure, 
subplot(1, 3, 1)
imagesc(x)
axis off
title('X')

subplot(1, 3, 2)
imagesc(Ft_t)
axis off
title('Ft_t')

subplot(1, 3, 3)
scatter(x(:), Ft_t(:))
xlabel('x')
ylabel('Ft_t')
title('X')

%% Q6: this was done for one trial, do the above for all trials
element = 18;
for tr = 1 : size(Kon_2{element}, 3)
    tform =  trans_att_in{element, 1}(tr);
        for time = 1 : 31
            ft = Ke(:, :, tr, time); % 316x316
            ft_t(:, :, time) = imwarp(ft, tform, 'OutputView', outputView); 
        end
%     Ft_t = nanmean(ft_t, 3);
%     Ft_t(Ft_t == 0) = nan;
    FTT(:, :, tr, :) = ft_t;
    tr
end

%% 
X = nanmean(FTT, 4);
x = trans_att_in{element, 2};

mX = nanmean(X, 3);
mx = nanmean(x, 3);
mx(mx == 0) = nan;
mX(mX == 0) = nan;

figure, 
subplot(1, 3, 1)
imagesc(mx)
axis off
title('mx')

subplot(1, 3, 2)
imagesc(mX)
axis off
title('mX')

subplot(1, 3, 3)
scatter(mx(:), mX(:))
xlabel('mx')
ylabel('mX')



%% Checking individual trials. Issue, some trials are correlated some are not
tr = 18;
a = nanmean(FTT(:, :, tr, :), 4);
b = trans_att_in{element, 2}(:, :, tr);
a(isnan(a)) = 0;
b(isnan(b)) = 0;
corr(a(:), b(:))
figure, scatter(a(:), b(:))

%% Eliminate and record those trials which are not well correlated
notcorr_list = [];

figure, 
hold all
for tr = 1 : 195
a = nanmean(FTT(:, :, tr, :), 4);
b = trans_att_in{element, 2}(:, :, tr);
scatter(a(:), b(:))
a(isnan(a)) = 0;
b(isnan(b)) = 0;
if  corr(a(:), b(:)) < .99999
notcorr_list = [notcorr_list; tr];
end
tr
end

A = [];
corr_list = [];

figure;
hold all;
k = 1;
for tr = 1:195
    if ismember(tr, notcorr_list)
        continue;
    else
        a = nanmean(FTT(:, :, tr, :), 4);
        b = trans_att_in{element, 2}(:, :, tr);
        A(:, :, k) = a;
        scatter(a(:), b(:));
        corr_list = [corr_list; tr];
        k = k + 1;
    end
    tr
end

%%
figure, 
hold all
for j = 1 : size(A, 3)
    a = A(:, :, j);
    b = trans_att_in{element, 2}(:, :, corr_list(j));
    tai_2(:, :, j) = b;
    scatter(a(:), b(:));
    j
end

%%
A(isnan(A)) = 0;
mA = nanmean(A, 3);
mx = nanmean(tai_2, 3);
% mA(mA == 0) = nan;
figure, 
subplot(1, 2, 1)
imagesc(mA)

subplot(1, 2, 2)
imagesc(mx)

figure, 
scatter(mA(:), mx(:))

%%
c = imgaussfilt(mA, 3);
figure, imagesc(c)

%%
figure, 
subplot(1, 2, 1)
imagesc(imgaussfilt(A(:, :, 1), 5))

subplot(1, 2, 2)
imagesc(imgaussfilt(A(:, :, 4), 5))
