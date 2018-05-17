function kernel = blur_kernel( blurPix, blurPix_int )

% squarred blur radius
blurPix_2 = blurPix^2;

% blur kernel size
blurSize = 2*blurPix_int +1;

% create the kernel
kernel = ones(blurSize,blurSize);

% go through one quarter of the kernel - it is radially symmetric so we can
% fill the values in by copying
for j=1:blurPix_int+1
    for i=1:blurPix_int+1
        
        % if the current pixel of the kernel matrix is outside of the blur
        % kernel
        if ((blurPix_int+1-j + 0.5)^2 + (blurPix_int+1-i + 0.5)^2 > blurPix_2)
            
            % kernel values are 0 at these places
            kernel(j,i) = 0;
            kernel(blurSize+1-j,i) = 0;
            kernel(j,blurSize+1-i) = 0;
            kernel(blurSize+1-j,blurSize+1-i) = 0;
            
        end
    end
end

% normalize the kernel
kernel = kernel/sum(kernel(:));

end
