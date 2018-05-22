function linear = bilinear(img)
%filter for red and blue
filter_rb = [1,2,1,2,4,2,1,2,1]/4;
filter_rb = reshape(filter_rb,3,3);
%filter for green
filter_g = [0,1,0,1,4,1,0,1,0]/4;
filter_g = reshape(filter_g,3,3);

linear = zeros(size(img));
%loop through image without boundary pixels
for i=2:767
    for j=2:511
        %set rgb to zero
        red = 0;
        green = 0;
        blue = 0;
        for m=-1:1
            for n=-1:1
                red = red + img(i+m,j+n,1)*filter_rb(m+2,n+2);
                green = green + img(i+m,j+n,2)*filter_g(m+2,n+2);
                blue = blue + img(i+m,j+n,3)*filter_rb(m+2,n+2);
            end
        end
        linear(i,j,1) = red;
        linear(i,j,2) = green;
        linear(i,j,3) = blue;
    end
end
