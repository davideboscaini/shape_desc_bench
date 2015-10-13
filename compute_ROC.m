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
    %dists_pos    = [errs_(idxs_.gt);errs_(idxs_.gt_sym)];
    %dists_neg    = errs_(setdiff(1:length(errs_),union(idxs_.gt,idxs_.gt_sym)));
else
    idxs_.gt  = sub2ind([n,n],idxs.gt,idxs.gt); 
    dists_pos = errs_(idxs_.gt);
    dists_neg = errs_(setdiff(1:length(errs_),idxs_.gt));
end

%[eer,~,~,~,~,~,~,fp,fn] = calculate_rates(dists_pos,dists_neg);
[fp,fn] = compute_fp_and_fn(dists_pos,dists_neg);

%
x_ = fp;
y_ = 1-fn;

%
%idxs = floor(linspace(1,length(x_),1001));
%x = x_(idxs);
%y = y_(idxs);

%
n_samples = 101;
% disp('1');
x = linspace(min(x_),max(x_),n_samples)';

y = interp1q(x_,y_,x);

% disp('2');
% tic;
% y = interparc(x./max(x),x_(1:100000:end),y_(1:100000:end),'spline');
% toc;

end

function [fp,fn] = compute_fp_and_fn(dp,dn)
np = length(dp);
nn = length(dn);

[d0, idx] = sort([dp(:); dn(:)], 'ascend');

d0    = [d0(1)-1; d0(:)];
delta = [d0(2:end)-d0(1:end-1); 0];
d     = d0 + delta;

l = [ones(np,1); -ones(nn,1)];
p = [0; (l(idx)>0)];
n = [0; (l(idx)<0)];

p  = p/sum(p);
fn = 1-cumsum(p);
n  = n/sum(n);
fp = cumsum(n);
end
