close all;
clear all;
clc;

%% load image
orig = double(imread('lena_color_256.tif'))/255;
orig = imresize(orig,0.2); % shrink the image for debugging

%% Create operator matrix A
[h, w, c] = size(orig);
black_prob = 0.3; % percentage of dark pixels
A = rand([h,w]);
A = A > black_prob;
A = cat(c,A,A,A);

%% Gradient operators as global variables
imgSize = size(orig);
global Gx; global Gy;
[Gx Gy] = grad_operator(imgSize(1:2));

%% Simulate deteriorated image b
b = orig.*A;

%% Optimization parameters
stepsz = 0.1; % step size of gradient descent
maxit = 1000; % iteration step
tol = eps; % stopping criteria: relative difference of results

%% Optimization with TV regularizer
lambda1 = 1.5e-2; % regularizer weight for TV
x_tv = graddesc(A,b,stepsz,lambda1,[],maxit,tol, 1);

%% Optimization with L2 gradient regularizer
lambda2 = 6.5e-2; % regularizer weight for L2
x_l2 = graddesc(A,b,stepsz,lambda2,[],maxit,tol, 2);

%% Optimization with TV + L2
lambda3 = 5e-2; % regularizer weight for TV + L2
beta = 0.15; % weight of combination of TV + L2
x_mix = graddesc(A,b,stepsz,lambda3,beta,maxit,tol, 3);

%% PSNR metric
p_cor = psnr(b,orig);
p_tv = psnr(x_tv,orig);
p_l2 = psnr(x_l2,orig);
p_mix = psnr(x_mix,orig);

%% Display all images
axes(1) = subplot(3,2,1);imshow(orig);title('Original');
axes(2) = subplot(3,2,2);imshow(b);title(strcat('Corrupted, PSNR = ',num2str(p_cor)));
axes(3) = subplot(3,2,3);imshow(x_tv);title(strcat('TV Inpainted, PSNR = ',num2str(p_tv)));
axes(4) = subplot(3,2,4);imshow(x_l2);title(strcat('L2 Inpainted, PSNR = ',num2str(p_l2)));
axes(5) = subplot(3,2,5);imshow(x_mix);title(strcat('TV+L2 Inpainted, PSNR = ',num2str(p_mix)));
linkaxes(axes);
