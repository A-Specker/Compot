function [Gx, Gy] = grad_operator(img_size)
n_pixel = img_size(1)*img_size(2);
Gx = sparse([1:n_pixel, 1:n_pixel-1], [1:n_pixel, 2:n_pixel], [-ones(1,n_pixel), ones(1,n_pixel-1)]/sqrt(2));
Gy = sparse([1:n_pixel, 1:n_pixel-img_size(1)], [1:n_pixel, img_size(1)+1:n_pixel], ...
    [-ones(1,n_pixel), ones(1,n_pixel-img_size(1))]/sqrt(2));
end