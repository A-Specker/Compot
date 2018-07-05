clear all;
close all;
clc;
clear classes;

%% load image
org = double(imread('lena_color_256.tif'))/255;

%% Create operator matrix A
A = bayer2mat();

%% Simulate mosaiced image b
b = A*org;

%% Gradient operators as global variables
imgSize = size(org);
global Gx; global Gy;
[Gx,Gy] = grad_operator(imgSize(1:2));


%% Optimization parameters
tol = eps;
maxiter = 500;
lambda = 0.05;
step_size = 5e-3;

%% Gradient Descent without TV
x_gd = graddesc(A,b,imgSize,step_size, [], maxiter,tol,0);

%% Gradient Descent with TV
x_gd_tv = graddesc(A,b,imgSize,step_size, lambda, maxiter, tol, 1);

%% PSNR metric
p_gd = psnr(reshape(x_gd,imgSize), org);
p_gd_tv = psnr(reshape(x_gd_tv,imgSize), org);



%% Dispaly Results
ax(1) = subplot(2,2,1);imshow(A*b);title('Original Image');
ax(2)=subplot(2,2,2);imshow(nearest(b));title(strcat('Nearest Neighbor, PSNR=', num2str(psnr(nearest(b),org))));
ax(3)=subplot(2,2,3);imshow(x_gd);title(strcat('Gradient Descent without TV, PSNR=', num2str(p_gd)));
ax(4)=subplot(2,2,4);imshow(x_gd_tv);title(strcat('Gradient Descent with TV, PSNR=', num2str(p_gd_tv)));
linkaxes(ax, 'xy');