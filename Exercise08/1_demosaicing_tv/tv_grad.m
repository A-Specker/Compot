function grad = tv_grad(x,imgSize)
x_rgb = reshape(x,imgSize);
% Compute gradient operators of x and y direction
global Gx; global Gy;
grad = reshape(zeros(imgSize), [], 3);
for ch=1:3
    % Each color channel is shaped into column vector
    temp_ch = reshape(x_rgb(:,:,ch),[],1);
    %% TODO: 1. a) compute gradient of TV, and put it into the variable called grad
    % compute image gradient of both directions independently
    [grad_x,grad_y] = imgradientxy(temp_ch);
    % evaluate sign vectors of the image gradients
    % also reshape into column vector
    grad_x = reshape(sign(Gx)*grad_x, [], 1);
    grad_y = reshape(sign(Gy)*grad_y, [], 1);
    
    % Average the gradients of two directions
    temp_ch = (grad_x+grad_y) / 2;
    grad(:,ch) = temp_ch; % here is an example to store the graddient into a number_of_pixel by 3 matrix.
end
% Reshape gradient to column vector
grad = reshape(grad,[],1);
end