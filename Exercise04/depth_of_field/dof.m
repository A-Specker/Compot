close all;
clear all;
clc;

% open the all-in-focus image
img = bin_import('sponza_normal.flt');

% open the per-pixel depth image
depthImg = bin_import('sponza_depth.flt');

% image dimensions
imgDim = size(img);

% lens focal length
f = 0.02625;

% aperture radius
apR = 0.05;

% sensor x,y dimensions (square sensor surface, aspect ratio = 1)
sensorSize = 0.024;

% focus distance
focusDist = 1;

% pixel width,height
pixSize = sensorSize/imgDim(1);

% compute distance from the lens plane to the sensor plane


% precompute the blur kernel radii blurR for all pixels


% precompute the blur size (in pixels) for all pixels - the value of blurR
% in pixels
blurPixR = blurR/pixSize;

% precompute the blur size (in rounded off pixels) for all pixels
blurPixR_int = floor(blurPixR);

% extract the maximum kernel size
maxBlur = max(blurPixR_int(:));

% pad the original image with the border pixels; the border should be
% allow for blurring with the largest kernel size

% we create the space for the depth-blurred image and the accumulation
% buffer
blurImg = zeros(size(img));
accumBuff = zeros(size(img,1),size(img,2));

for j=maxBlur+1:imgDim(1)+maxBlur
    for i=maxBlur+1:imgDim(2)+maxBlur

        % if kernel size is 0 (that means it is smaller than the pixel size) then there is no
        % blur - otherwise we compute the blur for the current
        % pixel
        currBlurPixR = blurPixR_int(j-maxBlur,i-maxBlur);

        if (currBlurPixR==0)

            % just copy the pixel if there is no blurring and update
            % the accumBuff
            
        else
            
            % get the current blur kernel
            kernel = blur_kernel(blurPixR(j-maxBlur,i-maxBlur), currBlurPixR);

            % perform the splatting in image space

            % update the accumulation buffer

        end
    end
end

% normalize the image

% write the image as jpg
imwrite(blurImg(maxBlur+1:imgDim(1)+maxBlur,maxBlur+1:imgDim(2)+maxBlur,:),'sponza_blurred.jpg','jpg');

