%% function to reconstruct the color image from the three given images images
function [img] = reconstruct(R, G, B)
    img = cat(3, R,G,B);        
end

