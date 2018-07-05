function [tv, grad] = total_variation(x, bitdepth)
% total_variation computes the total variation, i.e. sum(|grad(x)|),
% of an image and its corresponding gradient.
%
% Michael Hirsch (c) 2013
    
if ~exist('bitdepth', 'var')||isempty('bitdepth'), bitdepth = 255.; end

G = grad2mat(2,[size(x,1),size(x,2)],'same'); 
gx = G * x;

tv = sum(vec(abs(gx{1}) + abs(gx{2})));

gxx = gx{1};
gxx(gxx>0) =  1./bitdepth;
gxx(gxx<0) = -1./bitdepth;
gxy = gx{2};
gxy(gxy>0) =  1./bitdepth;
gxy(gxy<0) = -1./bitdepth;

grad = -1. * (G' * {gxx, gxy});
