clear all
close all

batchno = 1;
subfolder = 1;
thr = 8;
clrs = ['rgb'];
h1 = figure; hold on

for setno = 1:3
	load(['outputs_1/results/set_' num2str(setno) '/result_new.mat'],'finTable');
	for I = 1:size(finTable,1)
		fieldno = finTable(I,8);
        	cellnum = finTable(I,9);
		load(['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(cellnum) '/final_info.mat'],'Dbothfin');
		areas{setno}(I) = sum(sum(binswitch(Dbothfin(:,:,1))));
	end
	tottub{setno} = finTable(:,1).*finTable(:,2);
	[a,b] = hist(areas{setno},min([10,length(unique(areas{setno}))]));
	plot(b,a./sum(a(:)),['*-' clrs(setno)],'LineWidth',2.0,'Marker','o','MarkerFaceColor',[0.5 0.5 0.5], 'MarkerEdgeColor',[0 0 0],'MarkerSize',2.0);
        set(h1,'color','white');
        set(gca,'Box','off');
end

xlabel('Cell Size (2D Pixel Area)','FontSize',17)
ylabel('Normalized frequency','FontSize',17)
AX = legend('A431','U2OS','U251MG');
LEG = findobj(AX,'type','text');
set(LEG,'FontSize',17)
set(gca,'FontSize',17)
saveas(h1,['areahistfig.png'],'png');

hold off
h2 = figure; hold on
allareas = [];
alltottub = [];
for setno = 1:3
	allareas = [allareas,areas{setno}];
	alltottub = [alltottub,[tottub{setno}]'];
end
plot(allareas,alltottub,'.')

[xx,ii] = sort(allareas);
yy = alltottub(ii);
p = polyfit(xx,yy,1);
yfit = polyval(p,xx);
plot(xx,yfit,'k','LineWidth',2.0);
set(h2,'color','white');
set(gca,'Box','off');

xlabel('Cell Size (2D Pixel Area)','FontSize',17)
ylabel('Number x Mean of length','FontSize',17)
AX = legend('Cells','Linear fit');
LEG = findobj(AX,'type','text');
set(LEG,'FontSize',17)
set(gca,'FontSize',17);

saveas(h2,['areacorr.png'],'png');
