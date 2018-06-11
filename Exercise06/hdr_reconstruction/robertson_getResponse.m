function [ hdrimg, curve ] = robertson_getResponse( images, times, I, channel)

maxit = 100;
maxdelta = 0.0005;

%% initalization
% perform the first step of the Robertson algorithm

% initialize the response function I and Ip (I in the previous iteration -
% used as a stopping criterion).
[I, x] = normalize(I);
Ip = I;

% apply Robertson to get first HDR image estimate
hdrimg = robertson_applyResponse(images, times, I, channel);


%% optimization
it_count = 0;
delta = 5000;

while(delta > maxdelta)

    % step 1: minimize the objective function with respect to I
    %   compute the response function estimate I (equation 10 from the paper);
    %   I has to be monotonically increasing (beware of a lost zero between
    %   two nonzero values)!
    %   (hint: to avoid extra for loops you could use the "conditional indices"
    %   as mentioned in the assignment.
   
    E_m = cell(length(images),1);
    %loop through 0:255
    for m=0:255
        sum = 0;
        for i=1:length(images)
            %current image
            cur_img = images{i};
            E_m{i} = find(cur_img(:,:,channel) == m);
        end
        card = 0;
        for i=1:length(images)
            %find first value ~= 0
            for j=1:length(E_m{i})
                sum = sum + times(i)*I(1+images{i}(j));
                card = card + 1;
            end
        end
        I(m+1) = (1/card)*sum;
    end
    % step 2: normalize I
    [I, mid] = normalize(I);

    
    % step 3: apply new response
    hdrimg = robertson_applyResponse(images, times, I, channel);

    
    % step 4: check stopping condition delta - use the squared difference
    % between two consecutive response curve estimates.
    delta = (I-Ip).^2
    fprintf('    %d: delta = %g\n', it_count, delta);
    
    if(it_count == maxit)
        delta = 0;
    end
    
    it_count = it_count+1;
    Ip = I;
end

curve = I;

end


function [ normed, mid ] = normalize( I )
    %get min and max indices of response function where value ~= 0 so you
    %get the lower bound of range
    min_index = 0;
    %go through the values from 1 to the end
    for i=1:length(I)
        %check if you have a response
        if I(i) ~= 0.0
            %assign lower bound of range
            min_index = i;
            break
        end
    end
    
    %get the upper bound of range
    max_index = 0;
    %go throught the values from the end to 1
    for i=length(I):-1:1
        %check if you have a response
        if I(i) ~= 0.0
            %assign upper bound of range
            max_index = i;
            break
        end
    end
    
    %calculate the middle of the range and get the corresponding value
    mid_index = min_index + round((max_index - min_index) / 2); 
    mid_index
    mid = I(mid_index+1);
    
    %divide the response function by the mid_value so the value at the
    %middle of the range is 1.0 (only if value ~= 0)
    %otherwise search if there is a nearby value ~= 0.0
    if mid == 0.0
        while I(mid_index) == 0 && mid_index < 256
            mid_index = mid_index + 1;
        end
        
        mid = I(mid_index);
    end
    
    if mid ~=0.0
       normed = I./mid; 
    end
end
