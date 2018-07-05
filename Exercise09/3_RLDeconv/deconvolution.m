clear all;
close all;
clc;

%% Load image and kernel
pic = double(imread('../orig.tif'))/255;
kernel = double(imread('../blurkernel.png')); kernel = kernel/sum(sum(kernel));

%% Pad image to avoid boundary artifact
pic = padarray(pic,2*size(kernel),'symmetric','both');

%% Simulate blurred image
for c = 1:3
    blur_pic(:,:,c) = imfilter(pic(:,:,c),kernel);
end
sigma = 0.00002;
blur_pic = imnoise(blur_pic,'gaussian',0,sigma);
s = size(blur_pic);

%% Richardson-Lucy Algorithm
niter = 50;
PSNR = [];
for lambda = 0:0.1:2
    
    for c = 1:3
        % TODO: Implement Richardson-Lucy in deconv_rl
        I_rl(:,:,c) = deconv_rl(blur_pic(:,:,c), kernel, lambda, niter);
    end
    
    % Compute PSNR of cropped results
    PSNR = [PSNR, psnr(I_rl(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:), ...
        pic(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:))];
    fprintf('lambda: %f\n', lambda);
end

%% TODO: Plot PSNR VS lambda

%% Reference using MATLAB deconvlucy
reference = deconvlucy(blur_pic, kernel);

%% Crop the padded array
pic = pic(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
blur_pic = blur_pic(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
I_rl = I_rl(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
reference = reference(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);

%% Display
figure('Name','Output Richardson-Lucy');
ax(1) = subplot(1,4,1);
imshow(pic);
title('Original');
ax(2) = subplot(1,4,2);
imshow(blur_pic);
title('Blurred');
ax(3) = subplot(1,4,3);
imshow(I_rl);
title('Reconstruction');
ax(4) = subplot(1,4,4);
imshow(reference);
title('Reference');
linkaxes(ax);
