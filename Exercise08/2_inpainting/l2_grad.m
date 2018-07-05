function grad = l2_grad(x,imgSize)
x_rgb = reshape(x,imgSize);
% Compute gradient operators of x and y direction
global Gx; global Gy;
for ch=1:3
    % Each color channel is shaped into column vector
    temp_ch = reshape(x_rgb(:,:,ch),[],1);
    %% TODO: compute gradient of the L2 norm of image gradient, and put it into the variable called grad
    % compute gradient of both directions independently and average them
    
    grad_x = reshape(sign(sqrt((Gx*temp_ch).^2)), [], 1);
    
    grad_y = reshape(sign(sqrt((Gy*temp_ch).^2)), [], 1);
    
    grad(:,ch) = (grad_x+grad_y) / 2;
     
end
% Reshape the grad
grad = reshape(grad,[],1);
end