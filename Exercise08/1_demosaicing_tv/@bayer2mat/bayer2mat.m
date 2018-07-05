function obj = bayer2mat()
%BAYER2MAT creates a matrix object for Bayering 
% Michael Hirsch | March 2014

% store all stuff in the structure
obj.tp = false;    % is the resulting matrix transposed?
obj = class(obj, 'bayer2mat');
