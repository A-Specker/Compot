function [ image ]  = bin_import( filename )

fid = fopen(filename);

% the file format is as follows:
% 3 x 4-byte int for the dimensions x y and c (color channels)
% then there are c times x*y pixels in 4-byte float format,
% i.e. first all red pixels, then all green pixels and so on
% all numbers are little-endian
info = fread(fid, 3, 'uint32');
w = info(1);
h = info(2);
d = info(3);

% allocate the image
image = zeros(h, w, d);

% read in the pixels
for c = 1:d
    image(:,:,c) = vec2mat(fread(fid, h*w, 'float32')', w);
end

fclose(fid);
end
