function [ img ] = load_images(path, nr, startval)
 % loads 'nr' images specified by the formatted string 'path'
 
    img = cell(1,nr);
    
    if ~exist( 'startval', 'var' ),
        startval = 1;
    end
    
    for i = startval:startval+nr-1
        img{i-startval+1} = double(imread(sprintf(path,i)))/255;
    end
end

