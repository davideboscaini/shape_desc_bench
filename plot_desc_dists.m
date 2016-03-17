function plot_desc_dists(shapes,descs,params)

errs{1} = L2_distance(descs{1}',descs{1}');
errs{2} = L2_distance(descs{1}',descs{2}');

err{1} = saturate(errs{1}(params.idx,:))';
err{2} = saturate(errs{2}(params.idx,:))';

figure;
% left
subplot(1,2,1);
if isfield(shapes{1},'TRIV')
    plot_shape(shapes{1},err{1});
else
    plot_pc(shapes{1},err{1});
end
%hold on;
%plot3(shapes{1}.X(params.idx),shapes{1}.Y(params.idx),shapes{1}.Z(params.idx),'.k','markersize',30);
%hold off;
colormap(params.cmap);
if params.flag_same_caxis
    caxis([min([err{1};err{2}]),max([err{1};err{2}])]);
end
% right
subplot(1,2,2);
if isfield(shapes{2},'TRIV')
    plot_shape(shapes{2},err{2});
else
    plot_pc(shapes{2},err{2});
end
%hold on;
%plot3(shapes{2}.X(params.idx),shapes{2}.Y(params.idx),shapes{2}.Z(params.idx),'.g','markersize',30);
%[~,params.idx_] = min(err{2});
%plot3(shapes{2}.X(params.idx_),shapes{2}.Y(params.idx_),shapes{2}.Z(params.idx_),'.k','markersize',30);
%hold off;
colormap(params.cmap);
if params.flag_same_caxis
    caxis([min([err{1};err{2}]),max([err{1};err{2}])]);
end
