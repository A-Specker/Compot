function [filtered_img] = BilateralFilter(input,sigma_s, sigma_r)
    filtered_img = zeros(size(input));
    %kernelSize
    w = 2;
    

    %Gaussian kernel similar to the previous task
    wa1 = (repmat(abs(-w:w),[2*w+1,1,3])).^2;
    wa2 = (repmat(transpose(abs(-w:w)),[1,2*w+1,3])).^2;
    g_distance = gaussian_kernel((wa1+wa2)/2,sigma_s);

    for i=w+1:size(input,1)-w
        for j=w+1:size(input,2)-w
            %gaussian kernel size array
            tmp = input(i-w:i+w,j-w:j+w,:);
            %Gaussian kernel of for the range
            g_range = gaussian_kernel(abs(tmp-tmp(w,w)),sigma_r);

            %bilateral kernel is multiplication of both gaussian kernels
            bilat_kernel = g_distance.*g_range;
            bilat_kernel_sum = sum(sum(bilat_kernel));
            %normalize ...
            bilat_kernel = bilat_kernel./bilat_kernel_sum;

            %convolution
            filtered_img(i,j,:) = sum(sum(tmp.*bilat_kernel));
        end
    end

    %gaussian kernel, source: wikipedia
    function [ge] = gaussian_kernel(wa,s)
        const = 1/(2*pi*s^2);
        wa = exp((-wa(:,:,:).^2)./(2*s^2));
        ge = wa.*const;
    end

end