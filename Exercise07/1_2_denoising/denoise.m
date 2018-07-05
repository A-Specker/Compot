clear all;
close all;
clc;

ground_truth = double(imread('images/tablet.tiff'))/255;
noisy = double(imread('images/noisy_tablet.tiff'))/255;

%%%%%%%%%% EXERCISE 2 DEBUGGING Images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ground_truth = double(imread('images/tablet_smal l.tiff'))/255;
%noisy = imnoise(ground_truth,'gaussian', 0, 0.0005);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%% Other Images for testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ground_truth = double(imread('images/flowers.png'))/255;
%ground_truth = double(imread('images/dice.png'))/255;
%ground_truth = double(imread('images/man.png'))/255;
%noisy = imnoise(ground_truth,'gaussian', 0, 0.0005);  % << Always needed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error_noisy_matlab = immse(ground_truth, noisy) % matlab version of MSE
% 4.1.a) Implement your own Mean Square Error function and call it here.
error_noisy_self = MSE(noisy, ground_truth)% call your function here

psnr_noisy_matlab = psnr(noisy, ground_truth) % matlab version of PSNR
%4.1.b) Implement your own PSNR function and call it here.
psnr_noisy_self = PSNR(noisy, ground_truth); % call your function here

%4.1.c) Use a simple gauss filter on the noisy image
sigma_s = 1; % parameter for determining the weights in spacial filter
denoised_gauss = imgaussfilt(noisy,sigma_s);  % apply gauss filter to noisy image
psnr_gauss = PSNR(denoised_gauss, ground_truth); % determine the psnr

% 4.1.d) Implement your own Bilateral Filter
sigma_s = 2; % parameter for determining the weights in spacial filter
sigma_r = 0.1; % parameter for weighting in color space
denoised_bilateral = BilateralFilter(noisy,sigma_s,sigma_r); % use your bilateral filter on noisy image
psnr_bilateral = PSNR(denoised_bilateral, ground_truth); % determine the psnr


%% 2. Implement your own Non Local Means Filter
search_window_r = 5;      % parameter for search window radius
similarity_window_r = 3;  % parameter for similarity patch size (radius)
sigma = 0.075;            % parameter std deviation used for similarity determination
denoised_NLM = NonLocalMeansFilter(noisy,search_window_r, similarity_window_r, sigma); % call your NLM-Filter here
psnr_NLM = PSNR(denoised_NLM, ground_truth); % determine the psnr


%% Create a Plot
grey = ones(size(noisy)) * 0.5;

figure
subplot(3,3,1)
imshow(noisy)
title('Noisy Image')
subplot(3,3,2)
imshow(ground_truth)
title('Ground Truth')
subplot(3,3,3)
imshow(grey + noisy-ground_truth)
title('Only noise')
subplot(3,3,4)
imshow(denoised_gauss)
title('Gauss filtered')
subplot(3,3,5)
imshow(denoised_bilateral)
title('Bilateral filtered')
subplot(3,3,6)
imshow(denoised_NLM)
title('NLM-Filtered')
subplot(3,3,7)
imshow(grey + noisy-denoised_gauss)
title('noise - gauss')
subplot(3,3,8)
imshow(grey + noisy-denoised_bilateral)
title('noise - bilateral')
subplot(3,3,9)
imshow(grey + noisy-denoised_NLM)
title('noise - NLM')
