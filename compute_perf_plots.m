function [x_mean,y_mean] = compute_perf_plots(dist_func,idxs,paths,params)
%
% [x,y] = compute_perf_plots(idxs_query,idxs_target,paths,params)
%    given a descriptor computes some standard performance evaluation curves
%
% inputs:
%    dist_func, ...
%    idxs, struct containing the following fields:
%       'query',  indices of the query shapes
%       'target', indices of the target shapes
%    paths, struct containing the following fields:
%       'desc',     path to the descriptors
%       'idxs_sym', path to the symmetry indices
%       'dataset',  path to the dataset
%       'geods',    path to the geodesic distances
%    params, struct containing the following fields:
%       'curves', cell array containing the name of the performance evaluation curve to compute
%          e.g. 'CMC', 'ROC', 'Kim'
%

tmp    = dir(fullfile(paths.desc,'*.mat'));
names_ = sortn({tmp.name}); clear tmp;

names.query  = names_(idxs.query);
names.target = names_(idxs.target);

for idx_query = 1:length(idxs.query)
    
    % current query shape
    name_query = names.query{idx_query};
    
    % display info
    fprintf('[i] query shape ''%s'' (%3.0d/%3.0d):\n',name_query(1:end-4),idx_query,length(idxs.query));
    
    % load the descriptor
    tmp = load(fullfile(paths.desc,name_query));
    desc_query = tmp.desc;
    
    count = 1;
            
    for idx_target = 1:length(idxs.target)
        
        % current target shape
        name_target = names.target{idx_target};
        
        if ~strcmp(name_target,name_query)
            
            % display info
            fprintf('[i]    target shape ''%s'' (%3.0d/%3.0d)... ',name_target(1:end-4),idx_target,length(idxs.target));
            time_start = tic;
            
            % load the descriptor
            tmp = load(fullfile(paths.desc,name_target));
            desc_target = tmp.desc;
            
            % compute the error between the query descriptor and the target one
            errs = dist_func(desc_query,desc_target);
            
            % compute gt indices
            idxs.gt = [1:size(desc_target,1)]';
            
            % compute symmetry indices
            if params.flag_symmetry
                tmp = dir(fullfile(paths.idxs_sym,'*.mat'));
                names_tmp = sortn({tmp.name});
                for idx_tmp = 1:length(names_tmp)
                    if ~isempty(cell2mat(strfind(names_tmp(idx_tmp),'_idxs_sym.mat')))
                        tmp = load(fullfile(paths.idxs_sym,names_tmp{idx_tmp}));
                        idxs.gt_sym = tmp.idxs; clear tmp;
                    end
                end
            end
            
            for idx_curve = 1:length(params.curves)
                if strcmp(params.curves(idx_curve),'CMC')
                    [x{idx_curve}(:,count),y{idx_curve}(:,count)] = compute_CMC(errs,idxs);
                elseif strcmp(params.curves(idx_curve),'ROC')
                    [x{idx_curve}(:,count),y{idx_curve}(:,count)] = compute_ROC(errs,idxs);
                elseif strcmp(params.curves(idx_curve),'Kim')
                    % load the shape
                    tmp = load(fullfile(paths.dataset,name_target));
                    shape_target = tmp.shape;
                    % load the geodesic distances
                    tmp = load(fullfile(paths.geods,name_target));
                    shape_target.geods = tmp.geods;
                    %
                    func = @(x) min(x,[],2);
                    params.x_max = 0.3;
                    [x{idx_curve}(:,count),y{idx_curve}(:,count)] = compute_Kim(func,errs,idxs,shape_target,params);
                end
            end
            
            count = count + 1;
            
            % display info
            fprintf('%2.0fs\n',toc(time_start));
            
        end
        
    end
    
    %
    for idx_curve = 1:length(params.curves)
        x_tmp{idx_curve}(:,idx_query) = mean(x{idx_curve},2);
        y_tmp{idx_curve}(:,idx_query) = mean(y{idx_curve},2);
    end
    
end

%
for idx_curve = 1:length(params.curves)
    x_mean{idx_curve} = mean(x_tmp{idx_curve},2);
    y_mean{idx_curve} = mean(y_tmp{idx_curve},2);
end
