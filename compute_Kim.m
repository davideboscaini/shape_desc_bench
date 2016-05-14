function [x,y] = compute_Kim(func,pred,idxs,shape,params)
%
% [x,y] = compute_Kim...
%    computes the Kim curves according to the paper
%    " ", SIGGRAPH 201, ...
%
% inputs:
%    
% outputs:
%    x,
%    y,

if nargin < 5
    params.x_max = 0.3; 
end

%
geods = (shape.geods + shape.geods')/2;

%
[~,idxs.pred] = func(pred);

% compute the geodesic error:
if strcmp(params.geod_error,'hard')
    
    % hard-error
    if ~isfield(idxs,'gt_sym')
        errs = geods(sub2ind(size(geods),idxs.pred,idxs.gt));
    else
        errs = min(...
            geods(sub2ind(size(geods),idxs.pred,idxs.gt)),...
            geods(sub2ind(size(geods),idxs.pred,idxs.gt_sym))...
            );
        fprintf('[i] computing *symmetric* curves\n');
    end
    
elseif strcmp(params.geod_error,'soft')
    
    % soft-error
    % TODO: PUT SOFT-ERROR CODE HERE
    
end

if isfield(shape,'TRIV')
    % compute the area of the shape
    shape.area = compute_area([shape.X,shape.Y,shape.Z],shape.TRIV);
    % normalize the error by the shape area
    errs = errs./sqrt(shape.area);    
end

% quantization
n_samples = 100;
x = linspace(0,params.x_max,n_samples)';
y = zeros(n_samples,1);
for h = 1:n_samples
    y(h) = sum(errs<=x(h))/length(errs);
end
