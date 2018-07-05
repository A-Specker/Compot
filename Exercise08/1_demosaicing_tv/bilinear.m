function result = bilinear(bayer)
%BILINEAR Summary of this function goes here
%   Detailed explanation goes here

result = bayer;

maskx1 = .25 * [1,0,1; 0,0,0; 1,0,1];
maskx2 = .25 * [0,1,0; 1,0,1; 0,1,0];
%mask3x3 = [.25, .5, .25; .5, 0, .5; .25, .5, .25];

% red
result(:,:,1) = result(:,:,1) + filter2(maskx1,result(:,:,1));
result(:,:,1) = result(:,:,1) + filter2(maskx2,result(:,:,1));

% green
result(:,:,2) = result(:,:,2) + filter2(maskx2,result(:,:,2));

%blue
result(:,:,3) = result(:,:,3) + filter2(maskx1,result(:,:,3));
result(:,:,3) = result(:,:,3) + filter2(maskx2,result(:,:,3));

end
