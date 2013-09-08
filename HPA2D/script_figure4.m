clear all
close all


subfolder = 1;
feats = [];

for setno = 1:3
	load(['outputs_' num2str(subfolder) '/cluster/set_' num2str(setno) '/result.mat'],'feat_vec_all');
	keys{setno}(1) = size(feats,1)+1;
	feats = [feats;feat_vec_all];
	keys{setno}(2) = size(feats,1);
end

feats(:,sum(abs(feats),1)==0) = [];
% Normalize features
pars = zscore(feats);

a = mdscale(pdist(pars),2);

clrs = ['rgb'];
figure, hold on
for setno = 1:3
	idxs = keys{setno}(1):keys{setno}(2);
	plot(a(idxs,1),a(idxs,2),['*' num2str(clrs(setno))]);
end
axis([-0.5 0.5 -0.5 0.5])
labels{1} = 'MDS 1';
labels{2} = 'MDS 2';
xlabel(labels{1});
ylabel(labels{2});
close all
coords = a;
clear a
for labelno = [1:2]
        h1 = figure; hold on
        for setno = 1:3
		idxs = keys{setno}(1):keys{setno}(2);
                c = coords(idxs,labelno);
		c(c<-2) = [];
		size(c)
                [a,b] = hist(c,min([10,length(unique(c))]));
		a = a/sum(a(:));
                plot(b,a,['*-' clrs(setno)],'LineWidth',2.0,'Marker','o','MarkerFaceColor',[0.5 0.5 0.5], 'MarkerEdgeColor',[0 0 0],'MarkerSize',2.0);
		sum(a(:))
        end
        xlabel(labels{labelno},'FontSize',17)
        ylabel('Normalized frequency','FontSize',17)
        AX = legend('A431','U2OS','U251MG');
	LEG = findobj(AX,'type','text');
        set(LEG,'FontSize',17)
        set(gca,'FontSize',17)
        saveas(h1,['mdsfig_' num2str(labelno) '.png'],'png');
end
