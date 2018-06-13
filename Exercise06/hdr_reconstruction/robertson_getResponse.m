function [ hdrimg, curve] = robertson_getResponse( images, times, I, channel)

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
    % initialize E_m
    E_m = cell(length(images),1);
    %loop through 0:255
    for m=0:255
        sum_score = 0;
        % loop through the exposure times
        for i=1:length(images)
            %get the index set E_m = {(i,j):y_ij = m}
            E_m{i} = find(images{i}(:,:,channel) == m);
        end
        %variable for Card(E_m{i})
        card = 0;
        %variables needed for calculation of x_j
        x_j_counter = 0;
        x_j_denominator = 0;
        %loop through the exposure times
        for i=1:length(E_m)         
            %loop through the length of each E_m at the given exposure time
            for j=1:length(E_m{i})
                %exposure time
                t_i = times(i);
                % sum up x_j_counter and x_j_denominator (equation 8 in the
                % paper)
                x_j_counter = x_j_counter + weight(images{i}(channel*j))*t_i*I(1+images{i}(channel*j));
                x_j_denominator = x_j_denominator + weight(images{i}(channel*j))*t_i^2;
                
            end          
            %sum up the cardinality
            card = card + length(E_m{i});
        end
        %calculate x_j and afterwards I_m (equation 10 in the paper)
        x_j = x_j_counter / x_j_denominator;
        sum_score = sum_score + t_i*x_j;
        mon_inc = 0;
        if (m >= 1)
            mon_inc = I(m);
        end
        I(m+1) = mon_inc + (1/card)*sum_score;
    end
    % step 2: normalize I
    [I, mid] = normalize(I);

    
    % step 3: apply new response
    hdrimg = robertson_applyResponse(images, times, I, channel);

    
    % step 4: check stopping condition delta - use the squared difference
    % between two consecutive response curve estimates.
    delta = sum((I-Ip).^2);

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
