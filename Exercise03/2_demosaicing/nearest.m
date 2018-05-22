function simple = nearest(img)
    simple = zeros(size(img));
    %loop over image (dont consider edges at the bottom and at the right)
    for i=1:767
        for j=1:511
            %2x2 neighbours
            
            %if cur_pixel is red
            if img(i,j,2) == 0 && img(i,j,3) == 0
                %then top left is red
                red = img(i,j,1);
                %then green is average top right and bottom left
                green = (img(i+1,j,2)+img(i,j+1,2))/2;
                %then bottom right is blue
                blue = img(i+1,j+1,3);
            %if cur pixel is green and next to a red pixel
            elseif img(i,j,1) == 0 && img(i,j,3) == 0 && img(i,j+1,1) ~= 0
                %then top left is green
                green = img(i,j,2);
                %red is top right
                red = img(i,j+1,1);
                %blue is bottom left
                blue = img(i+1,j,3);
            %if cur pixel is green and next to a blue pixel
            elseif img(i,j,1) == 0 && img(i,j,3) == 0 && img(i,j+1,3) ~= 0
                %then top left is green
                green = img(i,j,2);
                %red is bottom left
                red = img(i+1,j,1);
                %blue is top right
                blue = img(i,j+1,3);
            %if cur pixel is blue
            elseif img(i,j,1) == 0 && img(i,j,2) == 0
                %then top left is blue
                blue = img(i,j,3);
                %bottom right is red
                red = img(i+1,j+1,1);
                %green is average between top right and bottom left
                green = (img(i+1,j,2)+img(i,j+1,2))/2;
            end
            %assign colors from nearest neighbours
            simple(i,j,1) = red;
            simple(i,j,2) = green;
            simple(i,j,3) = blue;        
        end
    end