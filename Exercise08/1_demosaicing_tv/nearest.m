function result = nearest(bayer)
%NEAREST Summary of this function goes here
%   Detailed explanation goes here

[x,y,z] = size(bayer);

result = bayer;
for i = 1:2:y-1
    for j = 1:2:x-1
        result(j:j+1,i:i+1,1) = result(j,i,1);
        result(j:j+1,i:i+1,2) = 0.5 * (result(j+1,i,2) + result(j,i+1,2));
        result(j:j+1,i:i+1,3) = result(j+1,i+1,3);
    end
end

end
