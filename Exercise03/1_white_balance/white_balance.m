%% white balancing

close all;
clear all;
clc;

% load color checker picture here
% (note that Matlab loads images with dimensions (height x width x channels)
A = double(imread('checker.tiff'))/255;

% correct rgb values for patches (left to right, top to bottom)
b = ([115, 82,  68;
     194, 150, 130;
     98,  122, 157;
     87,  108, 67;
     133, 128, 177;
     103, 189, 170;
     214, 126, 44;
     80,  91,  166;
     193, 90,  99;
     94,  60,  108;
     157, 188, 64;
     224, 163, 46;
     56,  61,  150;
     70,  148, 73;
     175, 54,  60;
     231, 199, 31;
     187, 86,  149;
     8,   133, 161;
     243, 243, 242;
     200, 200, 200;
     160, 160, 160;
     122, 122, 121;
     85,  85,  85;
     52,  52,  52]')/255;

% upper left and bottom right (y,x) coordinates of the first patch
coords = [80,  60;
          150, 130];

% delta for the patches in x and y directions
delta = 135;
 
% photo (r,g,b) values for each patch
cam = zeros(3,24);

% determine the color for each patch (elements of cam matrix), for each 
% patch calculate the mean value of the patch pixels
upper_left_y = coords(1,1);
bottom_right_y = coords(2,1);
upper_left_x = coords(1,2);
bottom_right_x = coords(2,2);

%iterate through the four rows
for row = 1:4
    for column = 1:6
        for c=1:3            
            cam(c,(row-1)*6+column) = mean2(A((upper_left_x:bottom_right_x)+(row-1)*delta, (upper_left_y:bottom_right_y)+(column-1)*delta,c));
        end
    end
end

% calculate the matrix Mat using the least squares method and matrices b,cam
Mat = transpose(cam)\transpose(b);
% apply the calculated matrix Mat to the image A
% wrong
%A = Mat*transpose(A);
for i=1:618
    for j=1:869
        rgb = A(i,j,:);
        rgb = reshape(rgb,1,3);
        A(i,j,:) = transpose(Mat)*transpose(rgb);
    end
end

% write out the end image
imwrite(uint8(A*255), 'checker_corrected.tiff', 'tiff');

% compare the results with reference image
ref = double(imread('checker_corrected_ref.tiff'))/255;
m = psnr(A,ref);
