function run_plot_perf_plots(path_input,path_output)
%
% run_plot_perf_plots(path_input,path_output)
%    plots ... and save 'tikz' files in the specified ouptu path
%
% inputs:
%    path_input,
%    path_output,
%

% dataset instances
tmp   = dir(fullfile(path_input,'*.mat'));
names = sortn({tmp.name}); clear tmp;

%
n_descs    = length(names);
perf_plots = cell(n_descs);

% loop over the dataset instances
for idx_desc = 1:n_descs
    
    % current shape
    name = names{idx_desc}(1:end-4);
    
    % display infos
    fprintf('[i] plotting descriptor ''%s'' (%3.0d/%3.0d)... ',name,idx_desc,n_descs);
    time_start = tic;
    
    % load current eigen-decomposition
    perf_plots{idx_desc} = load(fullfile(path_input,[name,'.mat']));
    
    perf_plots{idx_desc}.name = name;
    
    % display info
    fprintf('%2.0fs\n',toc(time_start));
    
end

% CMC
figure;
for idx_desc = 1:n_descs
    plot(perf_plots{idx_desc}.x{1},perf_plots{idx_desc}.y{1},'linewidth',1.5);
    if idx_desc == 1
        hold on;
    end
end
hold off;
xlim([0,100]);
ylim([0,1]);
axis square;
grid on;
set(gcf,'color','white');
set(gca,'XLim',[0,100]);
xlabel('number of matches');
ylabel('hit rate');
cleanfigure;
matlab2tikz(fullfile(path_output,'CMC.tikz'),'height','\figureheight','width','\figurewidth');

% ROC
figure;
for idx_desc = 1:n_descs
    semilogx(perf_plots{idx_desc}.x{2},perf_plots{idx_desc}.y{2},'linewidth',1.5);
    if idx_desc == 1
        hold on;
    end
end
hold off;
xlim([1e-04,1]);
ylim([0,1]);
axis square;
grid on;
set(gcf,'color','white');
set(gca,'XLim',[1e-04,1])
set(gca,'XTick',[1e-04,1e-03,1e-02,1e-01,1]);
set(gca,'XTickLabel',{'0.0001','0.001','0.01','0.1','1'});
xlabel('false positive rate');
ylabel('true positive rate');
cleanfigure;
matlab2tikz(fullfile(path_output,'ROC.tikz'),'height','\figureheight','width','\figurewidth');

% Kim
figure;
desc_names = cell(n_descs,1);
for idx_desc = 1:n_descs
    plot(perf_plots{idx_desc}.x{3},perf_plots{idx_desc}.y{3},'linewidth',1.5);
    if idx_desc == 1
        hold on;
    end
    desc_names{idx_desc} = strrep(perf_plots{idx_desc}.name,'_',' ');
end
hold off;
xlim([0,0.3]);
ylim([0,1]);
axis square;
grid on;
set(gcf,'color','white');
set(gca,'XLim',[0,0.3]);
set(gca,'XTick',[0,0.1,0.2,0.3]);
set(gca,'XTickLabel',{'0','0.1','0.2','0.3'});
xlabel('geodesic radius');
ylabel('% correct correspondences');
legend(desc_names,'location','southeast');
cleanfigure;
matlab2tikz(fullfile(path_output,'Kim.tikz'),'height','\figureheight','width','\figurewidth');
