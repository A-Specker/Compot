%answer for g):
%our image differs from the correctly ray traced image mainly on the pixels
%that are closer to the sensor, which is on the right side of the image
%where the pillars are. This could be due to the large differences of depth
%of the neighbouring pixels. You can also see this in the most different
%neighbouring colors in the Depth Map.

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
I = 1/(1/f-1/focusDist);

% precompute the blur kernel radii blurR for all pixels
% compute all distances from the lans plane to the sensor plane taking the
% depth image into account and all corresponding angles
I_s = zeros(size(depthImg));
blurR = zeros(size(depthImg));
for m=1:size(depthImg,1)
    for n=1:size(depthImg, 2)
        I_s(m,n) = abs(1/(1/f-1/depthImg(m,n)));
        blurR(m,n) = (apR/I_s(m,n))*abs(I-I_s(m,n));
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
img = padarray(img, [maxBlur, maxBlur], 'replicate', 'both');
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
            % perform the splatting in image spac
            for m = j-currBlurPixR: j+currBlurPixR
                for n = i-currBlurPixR: i+currBlurPixR
                    for c = 1:3
                        blurImg(m,n,c) = blurImg(m,n,c) + kernel(m -j+currBlurPixR + 1, n -i+currBlurPixR + 1) * img(j, i, c);
                    end
                    
                    % update the accumulation buffer
                    accumBuff(m,n) = accumBuff(m,n) + kernel(m -j+currBlurPixR + 1, n -i+currBlurPixR + 1);
                end
            end            
        end
    end
end

% normalize the image
blurImg(:,:,1) = blurImg(:,:,1)./(accumBuff);
blurImg(:,:,2) = blurImg(:,:,2)./(accumBuff);
blurImg(:,:,3) = blurImg(:,:,3)./(accumBuff);

% write the image as jpg
imshow(blurImg(maxBlur+1:imgDim(1)+maxBlur,maxBlur+1:imgDim(2)+maxBlur,:))
imwrite(blurImg(maxBlur+1:imgDim(1)+maxBlur,maxBlur+1:imgDim(2)+maxBlur,:),'sponza_blurred.jpg','jpg');

