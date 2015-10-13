function run_compute_perf_plots(paths,idxs,dist_func,params)
%
% run_compute_perf_plots(...)
%    given ..., computes ...
%
% inputs:
%    paths, struct containing the following fields:
%       'descs', cell array containig ...
%       'idxs_sym',
%       'saving',
%    idxs, struct containing the following fields:
%       'query',
%       'target',
%    dist_func,
%    params, struct containing the following fields:
%       'curves',
%       '',
%

%
for idx_desc = 1:length(paths.descs)
    
    %
    paths.desc = paths.descs{idx_desc};
    
    %
    tmp       = strfind(paths.desc,filesep);
    name_desc = paths.desc(tmp(end)+1:end);
    
    % display infos
    fprintf('[i] processing desc ''%s'' (%3.0d/%3.0d)... \n',name_desc,idx_desc,length(paths.descs));
    time_start = tic;
    
    %
    [x,y] = compute_perf_plots(dist_func,idxs,paths,params);
    
    % saving
    if ~exist(paths.saving,'dir')
        mkdir(paths.saving);
    end
    par_save(fullfile(paths.saving,[name_desc,'.mat']),x,y);
    
    % display info
    fprintf('%2.0fs\n',toc(time_start));
    
end

end

function par_save(path,x,y)
save(path,'x','y');
end
