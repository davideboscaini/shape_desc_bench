function [x,y] = compute_CMC(errs,idxs,varargin)
%
% [x,y] = compute_CMC(errs,gt,params)
%    computes the ...
% inputs:
%    errs,
%    gt, struct containing the fields 'idxs' and 'idxs_sym'
%    params,
% outputs:
%    x,
%    y,
%

if isempty(varargin)
    nn_max = 101;
else
    params = varargin{1};
    nn_max = params.nn_max;
end

[~,idxs_nn] = sort(errs,2,'ascend');
idxs_nn = idxs_nn(:,1:nn_max);

tmp_gt = abs(repmat(idxs.gt,1,nn_max)-idxs_nn);
tmp_gt = bsxfun(@eq,tmp_gt,zeros(size(tmp_gt)));
tmp_gt = cumsum(tmp_gt,2);
tmp_gt = bsxfun(@gt,tmp_gt,zeros(size(tmp_gt)));
y = mean(tmp_gt,1);

if isfield(idxs,'gt_sym')
    
    tmp_sym = abs(repmat(idxs.gt_sym,1,nn_max)-idxs_nn);
    tmp_sym = bsxfun(@eq,tmp_sym,zeros(size(tmp_sym)));
    tmp_sym = cumsum(tmp_sym,2);
    tmp_sym = bsxfun(@gt,tmp_sym,zeros(size(tmp_sym)));
    
    tmp_ = max(tmp_gt,tmp_sym);
    y    = mean(tmp_,1);
    
end

x = linspace(0,nn_max,length(y));

%y = bsxfun(@rdivide,tmp,1:nn_max);
%c = cumsum(t,2);
%c = bsxfun(@gt,c,zeros(size(c)));
%y = mean(c,1);
%x = linspace(0,nn_max,length(y));
