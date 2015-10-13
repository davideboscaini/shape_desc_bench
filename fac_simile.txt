clear;
close all;
clc;

% paths
paths.descs    = {...
    'G:\dboscaini\works\projects\??\datasets\FAUST_registrations\data\rototranslated\descs\SHOT_16dim'};
paths.idxs_sym = 'G:\dboscaini\works\projects\??\datasets\FAUST_registrations\data';
paths.idxs_FPS = 'G:\dboscaini\works\projects\??\datasets\FAUST_registrations\data';
paths.dataset  = 'G:\dboscaini\works\projects\??\datasets\FAUST_registrations\meshes\rototranslated';
paths.geods    = 'G:\dboscaini\works\projects\??\datasets\FAUST_registrations\data\rototranslated\geods';

% idxs
idxs.query  = 80+1;
idxs.target = 80+2:80+20;

% distance function
dist_func = @(x,y) L2_distance_squared(x',y');

% params
params.curves        = {'CMC','ROC','Kim'};
params.geod_error    = 'hard';

%
params.flag_symmetry = 1;
paths.saving         = 'G:\dboscaini\works\projects\??\perf_plots\sym';
run_compute_perf_plots(paths,idxs,dist_func,params);
run_plot_perf_plots(paths.saving,paths.saving);

%
params.flag_symmetry = 0;
paths.saving         = 'G:\dboscaini\works\projects\??\perf_plots\asym';
run_compute_perf_plots(paths,idxs,dist_func,params);
run_plot_perf_plots(paths.saving,paths.saving);
