clear all;
close all;
clc;

img = double(imread('lighthouse.ppm'))/255;
%% compute demosaiced images and their psnr value
bayer = img2bayer(img);
bayer_psnr = psnr(bayer,img);

% TODO: nearest neighbor method and bilinear method
simple = nearest(bayer);
simple_psnr = psnr(simple,img);

linear = bilinear(bayer);
linear_psnr = psnr(linear,img);

%% viz bilinear
figure('Name','Final');

subplot(2,3,1);
imshow(img);
title('Original - Full');

ax(1) = subplot(2,3,2);
imshow(img);
title('Original - Zoom');

ax(2) = subplot(2,3,3);
imshow(bayer);
title(strcat('Bayer pattern, PSNR: ', num2str(bayer_psnr)));

ax(3) = subplot(2,3,4);
imshow(simple);
title(strcat('Nearest Neighbour, PSNR: ', num2str(simple_psnr)));

ax(4) = subplot(2,3,5);
imshow(linear);
title(strcat('Bilinear Interpolation, PSNR: ', num2str(linear_psnr)));

linkaxes(ax, 'xy');