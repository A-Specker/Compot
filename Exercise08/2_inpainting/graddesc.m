function x = graddesc(A,b,stepsz,lambda, beta,maxit,tol, method)
imgSize = size(b);
% Reshape all images and residuals (error) to column vectors 
b = reshape(b,[],1);
A = reshape(A,[],1);
x = b;
r = A.*x - b; %% residual

for iter = 1:1:maxit
    x0 = x;
    r = A.*x - b;
    g = 2* A.* r; % mathematically this should be 2*A'*(A*x-b), the reason of using A.*r is that we stored the diagnal matrix A with image size
    switch method
        case 1
            %% TODO: 2. a) Gradient descent update of optimized results with TV regularizer
            E = abs(r).^2+lambda*tv_grad(x, imgSize);
            x = x-(stepsz*(g+E));
        case 2
            %% TODO: Gradient descent update of optimized results with L2 regularizer
            E = abs(r).^2+lambda*l2_grad(x, imgSize);
            x = x-(stepsz*(g+E));
            
        case 3
            %% TODO: Gradient descent update of optimized results with TV + L2 regularizers
            % use beta and lambda to weight the combination of regularizers
            E = abs(r).^2+lambda*((1-beta)*l2_grad(x,imgSize) + beta*tv_grad(x,imgSize));
            x = x-(stepsz*(g+E));
    end
    %%
    diff = norm(x-x0,'fro');
    if diff < tol
        break;
    end
    if method == 2
        diff
    end
end
% Reshape the image back to image size
x = reshape(x,imgSize);
end
