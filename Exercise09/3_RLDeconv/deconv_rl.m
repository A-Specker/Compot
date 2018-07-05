function o = deconv_rl(i, p, lambda, niter)
% deconv_rl implement the richardson-lucy deconvolution and improve the
% algorithm by adding a Total Variation(TV) regularizer.

% Set default values
if ~exist('lambda', 'var')||isempty('lambda'), lambda = 0.2; end
if ~exist('niter', 'var')||isempty('niter'), niter = 50; end

% Initialisation with input image
o = i;

%% TODO:Implement Richardson-Lucy Algorithm according to equation 6
fprintf('Start iterative RL updates: \n');
for i = 1:niter
    % TODO: Main algorithm without TV regularizer
    
    
    % TODO: Compute gradient of total variation regularizer using 
    % total_variation function. e.g.: total_variation(o). Multiply the 
    % regularizer to the algorithm.
    if lambda > 0 
        
    end
    o = o.* factor;
    
    fprintf('\r Iteration: %d/%d', i, niter);
end

% Project to positive domain
o(o<0.) = 0.;

fprintf('Done. \n');