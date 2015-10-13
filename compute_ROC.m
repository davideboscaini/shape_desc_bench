function [x,y] = compute_ROC(errs,idxs,varargin)

%
errs_ = errs(:);
n     = size(errs,1);

if isfield(idxs,'gt_sym')
    idxs_.gt     = sub2ind([n,n],idxs.gt,idxs.gt); 
    idxs_.gt_sym = sub2ind([n,n],idxs.gt,idxs.gt_sym); 
    [dists_pos,tmp_idxs] = min([errs_(idxs_.gt),errs_(idxs_.gt_sym)],[],2);
    tmp_idxs_gt     = find(tmp_idxs==1);
    tmp_idxs_gt_sym = find(tmp_idxs==2);
    dists_neg       = errs_(setdiff(1:length(errs_),union(tmp_idxs_gt,tmp_idxs_gt_sym)));
    % previous code:
    % dists_pos    = [errs_(idxs_.gt);errs_(idxs_.gt_sym)];
    % dists_neg    = errs_(setdiff(1:length(errs_),union(idxs_.gt,idxs_.gt_sym)));
else
    idxs_.gt  = sub2ind([n,n],idxs.gt,idxs.gt); 
    dists_pos = errs_(idxs_.gt);
    dists_neg = errs_(setdiff(1:length(errs_),idxs_.gt));
end

%
[fp,fn] = compute_fp_and_fn(dists_pos,dists_neg);

% previous code:
% [eer,~,~,~,~,~,~,fp,fn] = calculate_rates(dists_pos,dists_neg);

%
x_ = fp;
y_ = 1-fn;

%
n_samples = 101;
x = linspace(min(x_),max(x_),n_samples)';
y = interp1q(x_,y_,x);

end

function [fp,fn] = compute_fp_and_fn(dp,dn)
np = length(dp);
nn = length(dn);

[~, idx] = sort([dp(:); dn(:)], 'ascend');

l = [ones(np,1); -ones(nn,1)];
p = [0; (l(idx)>0)];
n = [0; (l(idx)<0)];

p  = p/sum(p);
fn = 1-cumsum(p);
n  = n/sum(n);
fp = cumsum(n);
end
