function [ hdrimg ] = robertson_applyResponse( images, times, I, channel )
% compute the given channel of the HDR image given the set of images,
% exposure time and a response curve
N = length(images);
%loop through all images
for m=1:size(images{1},1)
    for n=1:size(images{1},2)
        counter = 0;
        denominator = 0;
        %estimate the irradiance
        for i=1:N
            %the known observation
            y_ij = images{i}(m,n,channel);
            x_ij = I(y_ij+1)/times(i);
            counter = counter + weight(y_ij)*x_ij;
            denominator = denominator + weight(y_ij);
        end
        hdrimg(m,n) = counter / denominator;
    end

end
end
