clear all
close all


subfolder = 1;
clrs = ['rgb'];


celltype{1} = 'A431';
celltype{2} = 'U2OS';
celltype{3} = 'U251MG';


for setno = [1:3]
        load(['outputs_' num2str(subfolder) '/results/set_' num2str(setno) '/result_new.mat'],'finTable');
        finTable(:,10) = finTable(:,1).*finTable(:,2);
        finTable_all{setno} = finTable;
end


labels{2} = 'Mean of length distribution';
labels{1} = 'Number of microtubules';
labels{3} = 'Std deviation of length';
labels{4} = 'Collinearity';
labels{10} = 'Number x Mean of length';
labels{5} = 'Cell height x 5 (microns)';

for labelno = [1:5, 10]
	h1 = figure; hold on
	for setno = 1:3
		c = finTable_all{setno}(:,labelno);
		if labelno == 10 % if num x len
			 [a,b] = hist(c,min([10,length(unique(c))-4]));
		else
        		[a,b] = hist(c,min([10,length(unique(c))]));
		end
        	plot(b,a./sum(a(:)),['*-' clrs(setno)],'LineWidth',2.0,'Marker','o','MarkerFaceColor',[0.5 0.5 0.5], 'MarkerEdgeColor',[0 0 0],'MarkerSize',2.0);
		set(h1,'color','white');
		set(gca,'Box','off');
	end
	xlabel(labels{labelno},'FontSize',17)
	ylabel('Normalized frequency','FontSize',17)
	AX = legend('A431','U2OS','U251MG');
	LEG = findobj(AX,'type','text');
	set(LEG,'FontSize',17)
	set(gca,'FontSize',17)
	saveas(h1,['fig_' num2str(labelno) '.png'],'png');
end
