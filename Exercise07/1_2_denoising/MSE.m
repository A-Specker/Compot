function [mse] = MSE(img,reference)
    %subtract both images and sum up all the squared entries
    mse = sum(sum(sum(abs(img-reference).^2)));
    %divide by the number of summands
    mse = mse/(size(img,1)*size(img,2)*size(img,3));
end
    
