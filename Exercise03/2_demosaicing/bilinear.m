function linear = bilinear(img)
%filter for red and blue
filter_rb = [1,2,1,2,4,2,1,2,1]/4;
filter_rb = reshape(filter_rb,3,3);
%filter for green
filter_g = [0,1,0,1,4,1,0,1,0]/4;
filter_g = reshape(filter_g,3,3);

%convolve each channel with the corresponding filter
red = conv2(img(:,:,1), filter_rb);
green = conv2(img(:,:,2),filter_g);
blue = conv2(img(:,:,3),filter_rb);

%concatenate all three color channels and crop the border of the image, so
%the image has the same size as the input (important for calculating
%linear_psnr)
linear = cat(3,red, green, blue);
linear = imcrop(linear, [2 2 511 767]);
