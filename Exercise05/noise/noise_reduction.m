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
a1 = 0;
a2 = 0;
a3 = 0;
for n=1:nrDarkframes
    a1 = a1 + darkframes{n}(:,:,1);
    a2 = a2 + darkframes{n}(:,:,2);
    a3 = a3 + darkframes{n}(:,:,3);
end

a1 = a1 ./ nrDarkframes;
a2 = a2 ./ nrDarkframes;
a3 = a3 ./ nrDarkframes;

dark = cat(3,a1,a2,a3);
% compute the average image 'average' and apply the dark frame 'dark' to it
a1 = 0;
a2 = 0;
a3 = 0;
for n=1:nrImages
    a1 = a1 + images{n}(:,:,1);
    a2 = a2 + images{n}(:,:,2);
    a3 = a3 + images{n}(:,:,3);
end
a1 = a1 ./ nrDarkframes;
a2 = a2 ./ nrDarkframes;
a3 = a3 ./ nrDarkframes;

average = cat(3,a1,a2,a3);
average = average - dark;

imgSize = size(average);
blurImg = zeros(size(average));

kernelSize = 1;
gauss = fspecial('gaussian', 2*kernelSize+1, 1);

% compute the convolution of the image 'images{1} with the kernel gauss
% manually (no Matlab convolution functions ;))
for i=2:size(images{1},1)-1
    for j=2:size(images{1},2)-1
        for c=1:3
            for k1=-kernelSize:kernelSize
                for k2 = -kernelSize:kernelSize
                    blurImg(i,j,c) = blurImg(i,j,c) + gauss(k1+2, k2+2)*images{1}(i+k1,j+k2, c); 
                end
            end
        end
    end
end

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