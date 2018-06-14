function result = NonLocalMeansFilter(input, search_r, similarity_r, sigma)
%NonLocalMeansFilter Denoises the input image using the Non Local Means
%Algorithm
%   input        Noisy input image that is denoised by the function
%   search_r     Defines the radius around each pixel to seach for similar
%                pixels. In theory this would be the entire image, but for performance
%                reasons we limit the search to a window.
%   similarity_r Radius of a patch around a pixle that is used to determine
%                the similarity to other pixels (patches are compared)
%   sigma        standard deviation for determining the similarity between
%                patches (used in SimilarityWeight)

% allocate space for the result
dim = size(input);
result = zeros(dim);

% 4.2.b)
% Padd the input image to enable similarity comparison patches at the borders
% (miror the image at the borders!)
input_pad = input; %TODO

% create a waitbar to show progress
h = waitbar(0,'Applying NL Means filter...');
set(h,'Name','NL Means Filter Progress');


for y = 1 : dim(1)
    for x = 1 : dim(2)  
        
        % 4.2.c)
        % Extract a window around the pixel at position (y,x).
        % This window is then used to calculate the similarity to all other
        % pixels in the search radius of this pixel
        sim_window_pixel = zeros(2*similarity_r+1, 2*similarity_r+1, 3); % TODO
        
        
        pixel_average = zeros([1,1,3]);
        pixel_weight = 0;
        max_weight = 0;  
        
        %4.2.d)
        % * Iterate over all pixels in the search radius. Be carefull not
        %   to cross image boundaries.
        % * Skipp the loop if the pixel is at position (y,x)
        % * Else extract a similarity window around the pixel.
        % * Use the SimilarityWeight function from 4.2.a) to compute the
        %   weight of that pixel.
        % * Add the weighted pixel value to the average pixel value (pixel_average),
        %   and the weight to the total pixel weight (pixel_weight).
        % * Keep track of the maximum weight that was found. And use it to 
        %   weight the pixel (y,x) in the end (after the iteration).
       
        

        
        % 4.2.e) 
        % Write the result into the output image
    end    
    waitbar(y/dim(1));
end
close(h)
