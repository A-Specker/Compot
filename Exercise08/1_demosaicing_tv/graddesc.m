function x = graddesc(A,b,imgSize,stepsz,lambda,maxit,tol,method)
b = reshape(b,imgSize);
x = nearest(b);
% Reshape all images and residuals (error) to column vectors 
b = reshape(b,[],1);
r = reshape(A*x,[],1) - b; %% residual (error)
x = reshape(x,[],1);

for iter = 1:1:maxit
    x0 = x;
    % Compute gradient of the least squares (from last exercise)
    r = reshape(A*reshape(x,imgSize),[],1) - b;
    g = 2* reshape(A'* reshape(r,imgSize),[],1);
    switch method
        case 0
            % Gradient descent without TV
            x = x - stepsz*g;
        case 1
            %% TODO: 1.b) Gradient descent with tv
            % Add the gradient of TV to the gradient of the least squares,
            % use lambda as weight of the regularizer.
            E = abs(r).^2+lambda*tv_grad(x,imgSize);

            x = x-(stepsz*(g+E));
            
            
    end
    diff = norm(x-x0,'fro');
    if diff < tol
        break;
    end
    diff
end
% Reshape the image back to image size
x = reshape(x,imgSize);
end
