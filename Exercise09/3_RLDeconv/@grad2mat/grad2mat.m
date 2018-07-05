function obj = grad2mat(~, ~, shape)

if ~exist('shape','var')||isempty(shape), shape = 'valid'; end

obj.shape = shape;
obj.tp = false;    % transposed ?
obj = class(obj, 'grad2mat');
return
