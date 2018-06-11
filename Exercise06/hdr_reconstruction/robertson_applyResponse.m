function [ hdrimg ] = robertson_applyResponse( images, times, I, channel )
% compute the given channel of the HDR image given the set of images,
% exposure time and a response curve

N = length(images);

for m=size(images{1},1)
    for n=size(images{1},2)
        counter = 0;
        denominator = 0;
        for i=1:N
            if channel ~= 3
                "A"
                weight(n*size(images{i},2)+m*size(images{i},1))*times(i)*I(1+images{i}(m,n,channel))
            end
            "B"
            counter = counter + weight(n*size(images{i},2)+m*size(images{i},1))*times(i)*I(1+images{i}(m,n,channel));
            denominator = denominator + weight(n*size(images{i},2)+m*size(images{i},1))*times(i)^2;
        end
        hdrimg(m,n,channel) = counter / denominator;
    end

end
end
