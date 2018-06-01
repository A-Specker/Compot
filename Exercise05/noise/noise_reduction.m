% Noise reduction

clear all;
close all;
clc;

%% processing
% number of images and darkframes
nrImages = 16;
nrDarkframes = 16;

% load images
images = load_images('imgs\\%u.tiff', nrImages);
darkframes = load_images('dark\\%u.tiff', nrDarkframes);

average = zeros(size(images{1}));
dark = zeros(size(images{1}));
variance = zeros(size(images{1}));

% compute the average dark frame image 'dark'


% compute the average image 'average' and apply the dark frame 'dark' to it


imgSize = size(average);
blurImg = zeros(size(average));

kernelSize = 1;
gauss = fspecial('gaussian', 2*kernelSize+1, 1);

% compute the convolution of the image 'images{1} with the kernel gauss
% manually (no Matlab convolution functions ;))


% plot all (interesting) images
ax(1)=subplot(2,2,1);
imshow(images{1});

ax(2)=subplot(2,2,2);
imshow(dark*16,[]);

ax(3)=subplot(2,2,3);
imshow(blurImg);

ax(4)=subplot(2,2,4);
imshow(average);

linkaxes(ax,'xy');