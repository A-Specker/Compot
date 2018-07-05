clear all;
close all;
clc;

%% Load image and kernel
pic = double(imread('./orig.tif'))/255;
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

%% Calculate fast-fourier-transforms of blur kernel and image
kernel_fft = fft2(kernel,s(1),s(2));
blur_pic_fft = fft2(blur_pic);

%% TODO: Naive Fourier Deconvolution
% * truncate kernel_fft, prevents division through smaller numbers than 1e-3

% * reconstruction by division in fourier-space

% * perform the inverse fourier transform to obtain the results, save result
%   in variable named result

%% TODO: Fourier Deconvolution using Tikhonov Regularization
h = [0 -1 0;-1 4 -1;0 -1 0];
H = fft2(h,s(1),s(2)); % Laplacian operator (provided)

lambda_m = 0.0:0.005:0.5; % lambda space
for iter = 1:101
    lambda = lambda_m(iter);
    % TODO: Implement Fourier deconvolution with Tikhonov regularizer
    
    % save result in variable named result_reg
    
    % save results in cell array named result_reg_cell, e.g. 
    % result_reg_cell{iter} = zeros(size(pic));
    
end

%% Crop out the padded boundaries
pic = pic(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
blur_pic = blur_pic(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
result = result(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
result_reg = result_reg(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);

%% Display results
% Naive Fourier deconvolution
figure;
ax(1)=subplot(1,3,1);
imshow(pic,[])
title('Original');
ax(2)=subplot(1,3,2);
imshow(blur_pic,[])
title('Blurred+Noise');
ax(3)=subplot(1,3,3);
imshow(result,[])
title('Naive Reconstructed');
linkaxes(ax,'xy');

% Fourier Deconvolution using Tikhonov Regularization
figure;
bx(1)=subplot(1,3,1);
imshow(pic)
title('Original');
bx(2)=subplot(1,3,2);
imshow(blur_pic)
title('Blurred+Noise');
bx(3)=subplot(1,3,3);
imshow(result_reg_cell{9}(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:))
title('Tikhonov Regularizer Reconstructed');
linkaxes(bx,'xy');

%% GUI to show effect of lambda
% Press w to increase lambda
% press s to decrease lambda
% press a to set minimum lambda
% press d to set maximum lambda
lambda_gui(result_reg_cell,lambda_m, kernel);