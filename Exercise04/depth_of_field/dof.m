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
%lens equation: 1/o + 1/i = 1/f, we know g=focusDist and f:
%1/i=1/f-1/o ->i = 1/(1/f-1/g)
i = 1/(1/f-1/focusDist);

% precompute the blur kernel radii blurR for all pixels
% compute all distances from the lans plane to the sensor plane taking the
% depth image into account and all corresponding angles
i_s = zeros(size(depthImg));
blurR = zeros(size(depthImg));
for m=1:size(depthImg,1)
    for n=1:size(depthImg, 2)
        i_s(m,n) = 1/(1/f-1/depthImg(m,n));
        blurR(m,n) = (apR/i_s(m,n))*abs(i-i_s(m,n));
    end
end

% precompute the blur size (in pixels) for all pixels - the value of blurR
% in pixels
blurPixR = blurR/pixSize;

% precompute the blur size (in rounded off pixels) for all pixels
blurPixR_int = floor(blurPixR);

% extract the maximum kernel size
maxBlur = max(blurPixR_int(:));

% pad the original image with the border pixels; the border should be
% allow for blurring with the largest kernel size
img = padarray(img, [floor(maxBlur/2)+1, floor(maxBlur/2)+1], 'replicate', 'both');
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
            blurImg(j,i,:) = img(j,i,:);
            accumBuff(j,i) = 1;
            
        else
            
            % get the current blur kernel
            kernel = blur_kernel(blurPixR(j-maxBlur,i-maxBlur), currBlurPixR);
            a = floor(size(kernel,1)/2);
            b = floor(size(kernel,2)/2);
            % perform the splatting in image space
            for m=-a:-1
                for n=-b:-1
                    blurImg(j,i,:) = blurImg(j,i,:)+ img(j+m,i+n,:)*kernel(m+a+1,n+b+1);
                end
            end
            % update the accumulation buffer
            accumBuff(j,i) = 1;
        end
    end
end

% normalize the image
blurImg(:,:,1) = blurImg(:,:,1)./(accumBuff);
blurImg(:,:,2) = blurImg(:,:,2)./(accumBuff);
blurImg(:,:,3) = blurImg(:,:,3)./(accumBuff);

% write the image as jpg
imwrite(blurImg(maxBlur+1:imgDim(1)+maxBlur,maxBlur+1:imgDim(2)+maxBlur,:),'sponza_blurred.jpg','jpg');

