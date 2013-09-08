close all
clear all

if exist('show_real_results_s3_w7_all2_11lines.mat','file')
   load show_real_results_s3_w7_all2_11lines.mat
else
w2 = [1,1,1,1,1,1,1,0,0,0,0,0,0];
%w2 = [0,0,0,0,1,1,1,1,1,0,0,0,0];

subfolder = 3;

load ../HPA2D/real_allfeatures_w7_s3_11line2.mat finTable_all keys fin_mat_all keepidx
load HPAimagelist2.mat AddCellLines
load wrap_all_Celllines_cluster_s3.mat realMT keys_all area_Dbothfin 
idx = sum(abs(keys_all - repmat([10,1,4],[size(keys_all,1),1])),2); idx = find(idx==0);  %%
realMT(idx) = []; area_Dbothfin(idx) = []; clear keys_all
realMT = realMT(keepidx); area_Dbothfin = area_Dbothfin(keepidx);
keys_all = keys;
celllabels = keys(:,1);
fin_mat_all(:,[1:8]) = [];
CellLines = [{'A431'},{'U2OS'},{'U251MG'},AddCellLines];
CellLines = regexprep(CellLines,'CaCo','CaCo2');
markers = [{'+k'},{'om'},{'*c'},{'xr'},{'sg'},{'db'},{'^k'},{'vr'},{'>g'},{'<b'},{'hm'}];
end


%% show histograms, Figure 5
xlabels = [{'number of microtubules'},{'mean length of microtubule'},{'collinearity'}];
for setno = unique(celllabels')
	c = 0;
       %h(setno) = figure;
       for dd = [1,2,4]
           c = c + 1;
           %subplot(1, 3, c); 
           figure;
           idx = celllabels==setno;
           [n,xout] = hist(finTable_all(idx,dd),unique(finTable_all(:,dd))); 
           bar(xout,n/sum(n),'k'); %relative frequency is n/sum(n)
           set(gca,'FontName','Arial','FontSize',16,'FontWeight', 'bold','XTick',unique(finTable_all(:,dd)),'YTick',[0:0.1:round(100*max(n/sum(n)))/100]);
           %title(CellLines{setno});
           %xlabel(xlabels{dd}); ylabel('Relative frequency');
       end     
end


%% scatter plot, Figure 6
gmean = grpstats(finTable_all, keys(:,1), 'mean');
gstd = grpstats(finTable_all, keys(:,1), 'std');

h = figure; 
hold on;
for i = 1:length(CellLines)
    plot(gmean(i,2), gmean(i,1), markers{i});
    text(gmean(i,2), gmean(i,1), CellLines{i});
end
frac = zeros(length(CellLines),1);
for i = 1:length(CellLines)
    idx = keys(:,1)==i;
    mu = mean(finTable_all(idx,2:-1:1),1)';
    sigma = cov(finTable_all(idx,2:-1:1));
    [el,xy,index] = plotellipse(mu,sigma,1.5,finTable_all(idx,2:-1:1)',markers{i}(end));
    frac(i) = sum(index)/sum(idx);
end
legend(CellLines,'Location','SouthEast');
xlabel('mean of the length distribution (microns)'); ylabel('number of microtubules');
hold off;

%saveas(h, 'scatter_real1.eps', 'psc2');
%saveas(h, 'scatter_real1.tif', 'tiffn');
print(h, '-dpsc2', '-r300', 'scatter_real1.eps');
%print(h, '-dtiffn', '-r300', 'scatter_real1.tif');
print(h, '-dtiff', '-r300', 'scatter_real1.tif');



%% pairwise testing 
addpath(genpath('./SLIC'));

MBoxtest([celllabels,finTable_all(:,[1,2])]);

pooled = 0;  %% from the MBoxtest
nt = 100;  %%
pvalues_fin = zeros(length(CellLines), length(CellLines), nt);
ts_fin = zeros(length(CellLines), length(CellLines), nt);
[a,b] = hist(celllabels,unique(celllabels));
n = min(a);
rand('seed',13); randn('seed',13);
%ind_all = cell(length(CellLines),nt);  % another option
%for t = 1:nt
%for i = 1:length(CellLines)
%    ind1 = find(keys(:,1)==i); rp = randperm(length(ind1)); ind1 = ind1(rp(1:n));
%    ind_all{i,t} = ind1;
%end
%end 
for t = 1:nt
for i = 1:length(CellLines)
%    ind1 = ind_all{i,t};  % another option
    for j = 1:(i-1)
%        ind2 = ind_all{j,t}; 
        ind1 = find(keys(:,1)==i); rp = randperm(length(ind1)); ind1 = ind1(rp(1:n));
        ind2 = find(keys(:,1)==j); rp = randperm(length(ind2)); ind2 = ind2(rp(1:n));
        [pvalue,ts] = ml_ht2test2(finTable_all(ind1,1:2),finTable_all(ind2,1:2),pooled);
        pvalues_fin(i,j,t) = pvalue;
        ts_fin(i,j,t) = ts;
    end
end
pvalues_fin(:,:,t) = pvalues_fin(:,:,t) + pvalues_fin(:,:,t)';
pvalues_fin(:,:,t) = pvalues_fin(:,:,t) + eye(size(pvalues_fin(:,:,t)));
end

% hierarchical plot
X = max(ts_fin,[],3); X = X+X';  %%
Hier_out = jl_HierClust(X, 1:10);
Y = pdist(zscore(X));
Z = linkage(Y,'average');
h = figure;
[H,T,perm_fin] = dendrogram(Z,0,'labels',CellLines,'colorthreshold',0)
%saveas(h, 'hier_fin.eps', 'psc2');
%saveas(h, 'hier_fin.tif', 'tiffn');
print(h, '-dpsc2', '-r300', 'hier_fin.eps');
print(h, '-dtiff', '-r300', 'hier_fin.tif');


[COEFF,SCORE,latent] = princomp(fin_mat_all);
cumsum(latent)'./sum(latent)'
SCORE = SCORE(:,1:2);
MBoxtest([celllabels,SCORE]);
pooled = 0;  %% from the MBoxtest
pvalues_mat = zeros(length(CellLines), length(CellLines), nt);
ts_mat = zeros(length(CellLines), length(CellLines), nt);
for t = 1:nt
for i = 1:length(CellLines)
%    ind1 = ind_all{i,t};  % another option
    for j = 1:(i-1)
%        ind2 = ind_all{j,t};  % another option
        ind1 = find(keys(:,1)==i); rp = randperm(length(ind1)); ind1 = ind1(rp(1:n));
        ind2 = find(keys(:,1)==j); rp = randperm(length(ind2)); ind2 = ind2(rp(1:n));
        [pvalue,ts] = ml_ht2test2(SCORE(ind1,:),SCORE(ind2,:),pooled);
        pvalues_mat(i,j,t) = pvalue;
        ts_mat(i,j,t) = ts;
    end
end
pvalues_mat(:,:,t) = pvalues_mat(:,:,t) + pvalues_mat(:,:,t)';
pvalues_mat(:,:,t) = pvalues_mat(:,:,t) + eye(size(pvalues_mat(:,:,t)));
end

X = max(ts_mat,[],3); X = X+X';  %%
Hier_out = jl_HierClust(X, 1:10);
Y = pdist(zscore(X));
Z = linkage(Y,'average');
h = figure;
[H,T,perm_mat] = dendrogram(Z,0,'labels',CellLines,'colorthreshold',0)
%saveas(h, 'hier_mat.eps', 'psc2');
%saveas(h, 'hier_mat.tif', 'tiffn');
print(h, '-dpsc2', '-r300', 'hier_mat.eps');
print(h, '-dtiff', '-r300', 'hier_mat.tif');


% Table III
family = length(CellLines)*(length(CellLines)-1)/2*nt;  %%bonferroni
pvalues_fin = min(1,min(pvalues_fin*family,[],3));
pvalues_mat = min(1,min(pvalues_mat*family,[],3));
pvalues_fin_original = pvalues_fin; pvalues_mat_original = pvalues_mat;
pvalues_fin = pvalues_fin(perm_fin,perm_fin);
pvalues_mat = pvalues_mat(perm_mat,perm_mat);
pvalues_all = NaN(size(pvalues_fin));
pvalues_all(isnan(triu(pvalues_all,1))) = pvalues_mat(isnan(triu(pvalues_all,1)));
pvalues_all(isnan(tril(pvalues_all,-1))) = pvalues_fin(isnan(tril(pvalues_all,-1)));
%pvalues_all(isnan(pvalues_all)) = 1;
%{
pvalues_all = nan(length(CellLines), length(CellLines));
alpha = 0.05;
for i = 1:length(CellLines)
    for j = 1:(i-1)
	 pvalues = pvalues_fin(i,j,:);
	 [corrected_p, h]=bonf_holm(pvalues,alpha);  %%
	 pvalues_all(i,j) = min(corrected_p);  %%
    end
end
pvalues = pvalues_all(~isnan(pvalues_all));
pvalues = min(1,pvalues);
[corrected_p, h]=bonf_holm(pvalues,alpha);  %%
pvalues_all = squareform(min(1,corrected_p));
pvalues_all = pvalues_all + eye(size(pvalues_all));
%}



% hierarchical plot, Figure 7
h = figure;

subplot(2,1,1);
X = max(ts_fin,[],3); X = X+X';  %%
Y = pdist(zscore(X));
Z = linkage(Y,'average');
[H,T,perm_fin] = dendrogram(Z,0,'labels',CellLines,'colorthreshold',0);
set(gca, 'FontSize', 11,'Fontname','Arial')
set(H, 'color', 'k')
title('A','Fontsize',12,'Fontname','Arial','Fontweight','bold')

subplot(2,1,2);
X = max(ts_mat,[],3); X = X+X';  %%
Y = pdist(zscore(X));
Z = linkage(Y,'average');
[H,T,perm_mat] = dendrogram(Z,0,'labels',CellLines,'colorthreshold',0);
set(gca, 'FontSize', 11,'Fontname','Arial')
set(H, 'color', 'k')
title('B','Fontsize',11,'Fontname','Arial','Fontweight','bold')

print(h, '-dpsc2', '-r600', 'Figure4_new.eps');
print(h, '-dtiff', '-r600', 'Figure4_new.tif');
print(h, '-dpng', '-r600', 'Figure4_new.png');


%% plot amount, Figure 8
totalMT = finTable_all(:,1).*finTable_all(:,2);
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
xlabel('total tubulin fluorescence (8-bit grey scale intensities)'); ylabel('estimated total polymerized tubulin (microns)');
hold off;

%saveas(h1, 'amount.eps', 'psc2');
%saveas(h1, 'amount.tif', 'tiffn');
print(h1, '-dpsc2', '-r300', 'amount.eps');
print(h1, '-dtiff', '-r300', 'amount.tif');


%% plot area, Figure 9
corr3_all = zeros(length(CellLines),1);
h1 = figure; hold on;
for i = 1:length(CellLines)
    idx = find(keys_all(:,1)==i);

    ind = 1:length(idx);

    plot((area_Dbothfin(idx(ind))), (totalMT(idx(ind))), markers{i});
    corr3_all(i) = corr2((area_Dbothfin(idx(ind))), (totalMT(idx(ind))));
end
legend([char(CellLines(:)),num2str(round(100*corr3_all)/100)],'Location','SouthEast');
xlabel('cytosolic space (pixels)'); ylabel('estimated total polymerized tubulin (microns)');
hold off;
print(h1, '-dpsc2', '-r300', 'size.eps');
print(h1, '-dtiff', '-r300', 'size.tif');


save show_real_results_s3_w7_all2_11lines.mat
