function lambda_gui(result_reg_cell, lambda_p, kernel)
% This Gui allows to adapt the lambda setting of the result
% using the following keyboard input commands:
% Press w to increase lambda
% press s to decrease lambda
% press a to set minimum lambda
% press d to set maximum lambda

% open the gui - myKeyPress will handle keyboard events
figure('name', 'Lambda GUI', 'KeyPressFcn', @myKeyPress);
ax = subplot(1,1,1); % the axis to plot on

% show the image
counter = 1;
shown_img = result_reg_cell{counter};
shown_img = shown_img(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
displayed = imshow(shown_img);
title({strcat('Tikhonove Result Lambda: ', num2str(lambda_p(counter)))});

    function myKeyPress(src, event)
        key_id = double(event.Character);
        
        if(~ isempty(key_id))
            if(~isempty(key_id))
                switch(key_id)
                    case {30, 87, 119} % -- arrow up / w
                        counter = min(size(lambda_p,2),counter+1)
                        shown_img = result_reg_cell{counter};
                        shown_img = shown_img(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
                    case {31, 83, 115} % -- arrow down / s
                        counter = max(1,counter-1)
                        shown_img = result_reg_cell{counter};
                        shown_img = shown_img(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
                    case {97, 28} % -- arrow left / a first settings
                        counter = 1;
                        shown_img = result_reg_cell{counter};
                        shown_img = shown_img(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
                    case {100, 29} % -- arrow right / d last settings
                        counter = 100;
                        shown_img = result_reg_cell{counter};
                        shown_img = shown_img(2*size(kernel,1):end-2*size(kernel,1)+1,2*size(kernel,2):end-2*size(kernel,2)+1,:);
                end
            end
            
            % show the new confocal image in the gui
            set(displayed, 'CData', shown_img);
            set(get(ax, 'Title'), 'String', {strcat('Tikhonove Result Lambda: ', num2str(lambda_p(counter)))});
        end        
    end
end