clear all
close all

w = [1,1,1,1,1,1,1,0,0,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,1,1,1
     0,0,0,0,1,1,1,1,1,1,1,1,1
     1,1,1,1,1,1,1,1,1,1,1,1,1];

subfolder = 3;

CVs = zeros(8,5,size(w,1));
for i = 1:size(w,1)
for setno = 4:11
	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w(i,:)),'  ','_'),'.mat'],'finTable');
       disp([setno, w(i,:)]);
       CVs(setno-3,:,i) = nanstd(finTable(:,1:5),0,1)./nanmean(finTable(:,1:5),1);
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all

%w2 = [1,1,1,1,1,1,1,0,0,0,0,0,0];
w2 = [0,0,0,0,1,1,1,1,1,0,0,0,0];

subfolder = 3;

h = figure;
c = 0;
finTable_all = [];
celllabels = [];
keys = [];
load HPAimagelist2.mat AddCellLines
xlabels = [{'number of microtubules'},{'mean length of microtubule'},{'collinearity'}];
for setno = 4:7
	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w2(1,:)),'  ','_'),'.mat'],'finTable');

       keys = [keys; double(finTable(:,[end-2:end]))];
       finTable = double(finTable(:,[1,2,4]));  %%
       finTable_all = [finTable_all; finTable];
       celllabels = [celllabels; setno*ones(size(finTable,1),1)];
       for dd = 1:3
           c = c + 1;
           subplot(4, 3, c); 
           [n,xout] = hist(finTable(:,dd),unique(finTable(:,dd))); 
           bar(xout,n/sum(n)); %relative frequency is n/sum(n)
           title(AddCellLines{setno-3});
           xlabel(xlabels{dd}); ylabel('Relative frequency');
       end     
end

saveas(h,'hist_real1.fig');
saveas(h,'hist_real1.jpg');

c = 0;
for setno = 8:11
	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w2(1,:)),'  ','_'),'.mat'],'finTable');

       keys = [keys; double(finTable(:,[end-2:end]))];
       finTable = double(finTable(:,[1,2,4]));  %%
       finTable_all = [finTable_all; finTable];
       celllabels = [celllabels; setno*ones(size(finTable,1),1)];
       for dd = 1:3
           c = c + 1;
           subplot(4, 3, c); 
           [n,xout] = hist(finTable(:,dd),unique(finTable(:,dd))); 
           bar(xout,n/sum(n)); %relative frequency is n/sum(n)
           title(AddCellLines{setno-3});
           xlabel(xlabels{dd}); ylabel('Relative frequency');
       end     
end

saveas(h,'hist_real2.fig');
saveas(h,'hist_real2.jpg');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show the scatter plot of the estimated parameters for all 11 cell lines

close all
clear all

w2 = [1,1,1,1,1,1,1,0,0,0,0,0,0];
%w2 = [0,0,0,0,1,1,1,1,1,0,0,0,0];


%subfolder = 2;
subfolder = 3;

finTable_all = [];
celllabels = [];
keys = [];
for setno = 1:3
	load(['../HPA2D/outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w2(1,:)),'  ','_'),'.mat'],'finTable');

       keys = [keys; double(finTable(:,[end-2:end]))];
       finTable = double(finTable(:,[1,2,4]));  %%
       finTable_all = [finTable_all; finTable];
       celllabels = [celllabels; setno*ones(size(finTable,1),1)];
end
for setno = 4:11
	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w2(1,:)),'  ','_'),'.mat'],'finTable');

       keys = [keys; double(finTable(:,[end-2:end]))];
       finTable = double(finTable(:,[1,2,4]));  %%
       finTable_all = [finTable_all; finTable];
       celllabels = [celllabels; setno*ones(size(finTable,1),1)];
end

% plot
gmean = grpstats(finTable_all, keys(:,1), 'mean');
gstd = grpstats(finTable_all, keys(:,1), 'std');

load HPAimagelist2.mat AddCellLines
CellLines = [{'A431'},{'U2OS'},{'U251MG'},AddCellLines];
markers = [{'+k'},{'om'},{'*c'},{'xr'},{'sg'},{'db'},{'^k'},{'vr'},{'>g'},{'<b'},{'hm'}];

h = figure; 
hold on;
for i = 1:length(CellLines)
    plot(gmean(i,2), gmean(i,1), markers{i});
    text(gmean(i,2), gmean(i,1), CellLines{i});
end
for i = 1:length(CellLines)
    idx = keys(:,1)==i;
    mu = mean(finTable_all(idx,2:-1:1),1)';
    sigma = cov(finTable_all(idx,2:-1:1));
    plotellipse(mu,sigma,markers{i}(end));
end
legend(CellLines,'Location','SouthEast');
xlabel('mean of the length distribution'); ylabel('number of microtubules');
hold off;

saveas(h, 'scatter_real1.eps', 'psc2');


h = figure;
hold on;
for i = 1:length(CellLines)
    plot(gmean(i,2), gmean(i,1), markers{i});
    text(gmean(i,2), gmean(i,1), CellLines{i});

    idx = keys(:,1)==i;
    plot(finTable_all(idx,2), finTable_all(idx,1), markers{i});
end
xlabel('mean of the length distribution'); ylabel('number of microtubules');
hold off;

saveas(h, 'scatter_real2.eps', 'psc2');


totalMT = finTable_all(:,1).*finTable_all(:,2);

save show_real_results_s3_w7_all.mat -v4


% statistical testing


% real total amount of microtubules
load wrap_all_Celllines_cluster_s3.mat realMT keys_all2 area_Dbothfin rr major_Dbothfin area_dna major_segcell area_segcell 

sum(sum(abs(unique(keys_all2, 'rows')-keys_all2)))
sum(sum(abs(unique(keys, 'rows')-keys)))
keys_all = keys;

tf = ismember(keys_all2, keys, 'rows');

realMT = realMT(tf);
area_Dbothfin = area_Dbothfin(tf);
major_Dbothfin = major_Dbothfin(tf);
area_dna = area_dna(tf);
major_segcell = major_segcell(tf);
area_segcell = area_segcell(tf);

rr = 1.5; %%
%% plot
load HPAimagelist2.mat AddCellLines
AddCellLines = [{'A431'},{'U2OS'},{'U251MG'},AddCellLines];
markers = [{'+k'},{'om'},{'*c'},{'xr'},{'sg'},{'db'},{'^k'},{'vr'},{'>g'},{'<b'},{'hm'}];
h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
real_total = []; GG = [];
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = totalMT(idx)./realMT(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((realMT(idx(ind))), (totalMT(idx(ind))), markers{i});
    corr2_all(i) = corr2((realMT(idx(ind))), (totalMT(idx(ind))));

    real_total = [real_total;(totalMT(idx(ind)))./(realMT(idx(ind)))];
    GG = [GG;keys_all(idx(ind),1)];
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','NorthWest');
xlabel('(real total microtubule)'); ylabel('(estimated total microtubule)');
hold off;

saveas(h1, 'amount.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = totalMT(idx)./area_Dbothfin(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((area_Dbothfin(idx(ind))), (totalMT(idx(ind))), markers{i});
    corr2_all(i) = corr2((area_Dbothfin(idx(ind))), (totalMT(idx(ind))));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','NorthWest');
xlabel('(area of the cytosolic space in cell)'); ylabel('(estimated total microtubule)');
hold off;

saveas(h1, 'cytosolic.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = finTable_all(idx,1)./area_Dbothfin(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((area_Dbothfin(idx(ind))), (finTable_all(idx(ind),1)), markers{i});
    corr2_all(i) = corr2((area_Dbothfin(idx(ind))), (finTable_all(idx(ind),1)));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','SouthEast');
xlabel('(area of the cytosolic space in cell)'); ylabel('(estimated number of microtubules)');
hold off;

saveas(h1, 'cytosolic_n.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = finTable_all(idx,2)./area_Dbothfin(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((area_Dbothfin(idx(ind))), (finTable_all(idx(ind),2)), markers{i});
    corr2_all(i) = corr2((area_Dbothfin(idx(ind))), (finTable_all(idx(ind),2)));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','SouthEast');
xlabel('(area of the cytosolic space in cell)'); ylabel('(estimated mean of the length)');
hold off;

saveas(h1, 'cytosolic_mu.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = finTable_all(idx,1)./major_Dbothfin(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((major_Dbothfin(idx(ind))), (finTable_all(idx(ind),1)), markers{i});
    corr2_all(i) = corr2((major_Dbothfin(idx(ind))), (finTable_all(idx(ind),1)));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','SouthEast');
xlabel('(Major axis length of the cytosolic space in cell)'); ylabel('(estimated number of microtubules)');
hold off;

saveas(h1, 'major_n.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = finTable_all(idx,2)./major_Dbothfin(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((major_Dbothfin(idx(ind))), (finTable_all(idx(ind),2)), markers{i});
    corr2_all(i) = corr2((major_Dbothfin(idx(ind))), (finTable_all(idx(ind),2)));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','SouthEast');
xlabel('(Major axis length of the cytosolic space in cell)'); ylabel('(estimated mean of the length)');
hold off;

saveas(h1, 'major_mu.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = totalMT(idx)./major_Dbothfin(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((major_Dbothfin(idx(ind))), (totalMT(idx(ind))), markers{i});
    corr2_all(i) = corr2((major_Dbothfin(idx(ind))), (totalMT(idx(ind))));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','NorthWest');
xlabel('(Major axis length of the cytosolic space in cell)'); ylabel('(estimated total microtubule)');
hold off;

saveas(h1, 'major.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = totalMT(idx)./area_dna(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((area_dna(idx(ind))), (totalMT(idx(ind))), markers{i});
    corr2_all(i) = corr2((area_dna(idx(ind))), (totalMT(idx(ind))));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','NorthWest');
xlabel('(area of the nucleus space in cell)'); ylabel('(estimated total microtubule)');
hold off;

saveas(h1, 'dna.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = finTable_all(idx,1)./area_dna(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((area_dna(idx(ind))), (finTable_all(idx(ind),1)), markers{i});
    corr2_all(i) = corr2((area_dna(idx(ind))), (finTable_all(idx(ind),1)));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','SouthEast');
xlabel('(area of the nucleus space in cell)'); ylabel('(estimated number of microtubules)');
hold off;

saveas(h1, 'dna_n.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = finTable_all(idx,2)./area_dna(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((area_dna(idx(ind))), (finTable_all(idx(ind),2)), markers{i});
    corr2_all(i) = corr2((area_dna(idx(ind))), (finTable_all(idx(ind),2)));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','SouthEast');
xlabel('(area of the nucleus space in cell)'); ylabel('(estimated mean of the length)');
hold off;

saveas(h1, 'dna_mu.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = finTable_all(idx,1)./major_segcell(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((major_segcell(idx(ind))), (finTable_all(idx(ind),1)), markers{i});
    corr2_all(i) = corr2((major_segcell(idx(ind))), (finTable_all(idx(ind),1)));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','SouthEast');
xlabel('(Major axis length of the cell)'); ylabel('(estimated number of microtubules)');
hold off;

saveas(h1, 'major2_n.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = finTable_all(idx,2)./major_segcell(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((major_segcell(idx(ind))), (finTable_all(idx(ind),2)), markers{i});
    corr2_all(i) = corr2((major_segcell(idx(ind))), (finTable_all(idx(ind),2)));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','SouthEast');
xlabel('(Major axis length of the cell)'); ylabel('(estimated mean of the length)');
hold off;

saveas(h1, 'major2_mu.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = totalMT(idx)./major_segcell(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((major_segcell(idx(ind))), (totalMT(idx(ind))), markers{i});
    corr2_all(i) = corr2((major_segcell(idx(ind))), (totalMT(idx(ind))));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','NorthWest');
xlabel('(Major axis length of the cell)'); ylabel('(estimated total microtubule)');
hold off;

saveas(h1, 'major2.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = finTable_all(idx,1)./area_segcell(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((area_segcell(idx(ind))), (finTable_all(idx(ind),1)), markers{i});
    corr2_all(i) = corr2((area_segcell(idx(ind))), (finTable_all(idx(ind),1)));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','SouthEast');
xlabel('(area of the cell)'); ylabel('(estimated number of microtubules)');
hold off;

saveas(h1, 'cell_n.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = finTable_all(idx,2)./area_segcell(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((area_segcell(idx(ind))), (finTable_all(idx(ind),2)), markers{i});
    corr2_all(i) = corr2((area_segcell(idx(ind))), (finTable_all(idx(ind),2)));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','SouthEast');
xlabel('(area of the cell)'); ylabel('(estimated mean of the length)');
hold off;

saveas(h1, 'cell_mu.eps', 'psc2');


h1 = figure; hold on;
corr2_all = zeros(length(AddCellLines),1);
for i = 1:length(AddCellLines)
    idx = find(keys_all(:,1)==i);

    if i<=3
    x = totalMT(idx)./area_segcell(idx);
    xmean = median(x); 
    xstd = quantile(x,[0.25,0.75]); 
    ind = find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    else
    ind = 1:length(idx);
    end

    plot((area_segcell(idx(ind))), (totalMT(idx(ind))), markers{i});
    corr2_all(i) = corr2((area_segcell(idx(ind))), (totalMT(idx(ind))));
end
legend([char(AddCellLines(:)),num2str(round(100*corr2_all)/100)],'Location','NorthWest');
xlabel('(area of the cell)'); ylabel('(estimated total microtubule)');
hold off;

saveas(h1, 'cell.eps', 'psc2');



save show_real_results_s3_w7_all.mat -v4



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%version 2 and 3 in ISMB2012, use 10 cells for each cell line.

clear all
close all

addpath('/home/jieyuel/lib_backup/vesicleaffinity/tarball');
addpath(genpath('/home/jieyuel/lib_backup/rtag/randtag_scripts/SLIC'));


w2 = [1,1,1,1,1,1,1,0,0,0,0,0,0];

subfolder = 3;

finTable_all = [];
celllabels = [];
keys = [];
for setno = 1:3
	load(['../HPA2D/outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w2(1,:)),'  ','_'),'.mat'],'finTable');

       keys = [keys; double(finTable(:,[end-2:end]))];
       finTable = double(finTable(:,[1,2,4]));  %%
       finTable_all = [finTable_all; finTable];
       celllabels = [celllabels; setno*ones(size(finTable,1),1)];
end
for setno = 4:11
	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w2(1,:)),'  ','_'),'.mat'],'finTable');

       keys = [keys; double(finTable(:,[end-2:end]))];
       finTable = double(finTable(:,[1,2,4]));  %%
       finTable_all = [finTable_all; finTable];
       celllabels = [celllabels; setno*ones(size(finTable,1),1)];
end

fin_mat_all = [];

data1 = load('../HPA2D/real_allfeatures_w7_s3.mat');
keys1 = [];
for i = 1:3
    keys1 = [keys1; [i*ones(10,1), [1:10]', ones(10,1)]];
end
tf = ismember(data1.keys, keys1, 'rows');
fin_mat_all = [fin_mat_all; data1.fin_mat_all(tf, 9:end)];

data2 = load('allrealfeats_allfeats_allsetsw7.mat');
tf = ismember(data2.keys, keys, 'rows');
fin_mat_all = [fin_mat_all; data2.fin_mat_all(tf, :)];

keys_all = [keys1; data2.keys(tf,:)];

tf = ismember(keys, keys_all, 'rows');
finTable_all = finTable_all(tf, :);
celllabels = celllabels(tf);
keys = keys_all;

totalMT = finTable_all(:,1).*finTable_all(:,2);

load wrap_all_Celllines_cluster_s3.mat realMT keys_all2

sum(sum(abs(unique(keys_all2, 'rows')-keys_all2)))
sum(sum(abs(unique(keys, 'rows')-keys)))

tf = ismember(keys_all2, keys, 'rows');

realMT = realMT(tf);


save show_real_results_s3_w7_all2.mat -v4

%% plot

% scatter plot
gmean = grpstats(finTable_all, keys(:,1), 'mean');
gstd = grpstats(finTable_all, keys(:,1), 'std');

load HPAimagelist2.mat AddCellLines
CellLines = [{'A431'},{'U2OS'},{'U251MG'},AddCellLines];
markers = [{'+k'},{'om'},{'*c'},{'xr'},{'sg'},{'db'},{'^k'},{'vr'},{'>g'},{'<b'},{'hm'}];

h = figure; 
hold on;
for i = 1:length(CellLines)
    plot(gmean(i,2), gmean(i,1), markers{i});
    text(gmean(i,2), gmean(i,1), CellLines{i});
end
frac = zeros(length(CellLines),1);
for i = 1:length(CellLines)
    idx = keys(:,1)==i;
    %plot(finTable_all(idx,2),finTable_all(idx,1),'o');
    mu = mean(finTable_all(idx,2:-1:1),1)';
    sigma = cov(finTable_all(idx,2:-1:1));
    [el,xy,index] = plotellipse(mu,sigma,1.5,finTable_all(idx,2:-1:1)',markers{i}(end));
    frac(i) = sum(index)/sum(idx);
end
legend(CellLines,'Location','SouthEast');
xlabel('mean of the length distribution'); ylabel('number of microtubules');
hold off;

saveas(h, 'scatter_real1.eps', 'psc2');


% hierarchical plot
pooled = 0;  %% from the fligner.test
pvalues_fin = zeros(length(CellLines), length(CellLines));
ts_fin = zeros(length(CellLines), length(CellLines));
for i = 1:length(CellLines)
    for j = 1:length(CellLines)
        ind1 = keys(:,1)==i;
        ind2 = keys(:,1)==j;
        [pvalue,ts] = ml_ht2test2(finTable_all(ind1,1:2),finTable_all(ind2,1:2),pooled);
        pvalues_fin(i,j) = pvalue;
        ts_fin(i,j) = ts;
    end
end

X = ts_fin;
Y = pdist(zscore(X));
Z = linkage(Y,'average');
h = figure;
dendrogram(Z,'labels',CellLines)
saveas(h, 'hier_fin.eps', 'psc2');

[COEFF,SCORE,latent] = princomp(fin_mat_all);
cumsum(latent)'./sum(latent)'
SCORE = SCORE(:,1:2);
pooled = 0;  %% from the fligner.test
pvalues_mat = zeros(length(CellLines), length(CellLines));
ts_mat = zeros(length(CellLines), length(CellLines));
for i = 1:length(CellLines)
    for j = 1:length(CellLines)
        ind1 = keys(:,1)==i;
        ind2 = keys(:,1)==j;
        [pvalue,ts] = ml_ht2test2(SCORE(ind1,:),SCORE(ind2,:),pooled);
        pvalues_mat(i,j) = pvalue;
        ts_mat(i,j) = ts;
    end
end

X = ts_mat;
Y = pdist(zscore(X));
Z = linkage(Y,'average');
h = figure;
dendrogram(Z,'labels',CellLines)
saveas(h, 'hier_mat.eps', 'psc2');

family = length(CellLines)*(length(CellLines)-1)/2;
pvalues_fin = min(1,pvalues_fin*family);
pvalues_mat = min(1,pvalues_mat*family);
pvalues_all = NaN(size(pvalues_fin));
pvalues_all(isnan(triu(pvalues_all,1))) = pvalues_mat(isnan(triu(pvalues_all,1)));
pvalues_all(isnan(tril(pvalues_all,-1))) = pvalues_fin(isnan(tril(pvalues_all,-1)));


% plot amount
h1 = figure; hold on;
corr2_all = zeros(length(CellLines),1);
real_total = []; GG = [];
for i = 1:length(CellLines)
    idx = find(keys_all(:,1)==i);

    ind = 1:length(idx);

    plot((realMT(idx(ind))), (totalMT(idx(ind))), markers{i});
    corr2_all(i) = corr2((realMT(idx(ind))), (totalMT(idx(ind))));

    real_total = [real_total;(totalMT(idx(ind)))./(realMT(idx(ind)))];
    GG = [GG;keys_all(idx(ind),1)];
end
legend([char(CellLines(:)),num2str(round(100*corr2_all)/100)],'Location','NorthWest');
xlabel('total tubulin fluorescence'); ylabel('estimated total polymerized tubulin');
hold off;

saveas(h1, 'amount.eps', 'psc2');


for i = 1:3
for j = 1:2
    std(finTable_all(keys(:,1)==i,j))/mean(finTable_all(keys(:,1)==i,j))
end
end


save show_real_results_s3_w7_all2.mat -v4
