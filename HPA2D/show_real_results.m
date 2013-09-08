clear all
close all

w = [1;1;1;1;1;1;1];

for setno = 1:3
	load(['/home/ashariff/work52/outputs_1/results/set_',num2str(setno),'/result_new','.mat'],'finTable');
       disp([setno, w']);
       nanstd(finTable,0,1)./mean(finTable,1)
end



clear all
close all

%w = [1;1;1;1;1;1;1];
w = [1,1,1,1,1,1,1,0,0,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,1,1,1
     0,0,0,0,1,1,1,1,1,1,1,1,1
     1,1,1,1,1,1,1,1,1,1,1,1,1];

%subfolder = 2;
subfolder = 3;

for i = 1:size(w,1)
for setno = 1:3
	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w(i,:)),'  ','_'),'.mat'],'finTable');
       disp([setno, w(i,:)]);
       nanstd(finTable,0,1)./mean(finTable,1)
end
end



clear all
close all

w1 = [1;1;1;1;1;1;1];
w2 = [1,1,1,1,1,1,1,0,0,0,0,0,0];

%subfolder = 2;
subfolder = 3;

for setno = 1:3
	%load(['/home/ashariff/work52/outputs_1/results/set_',num2str(setno),'/result_new','.mat'],'finTable');
	load(['./outputs_',num2str(2),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w2(1,:)),'  ','_'),'.mat'],'finTable');
       finTable1 = finTable;
       maximg = length(num2str(max(finTable1(:,end)))); fieldcell1 = finTable1(:,end-1)*10^maximg + finTable1(:,end);

	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w2(1,:)),'  ','_'),'.mat'],'finTable');
       finTable2 = finTable;
       maximg = length(num2str(max(finTable2(:,end)))); fieldcell2 = finTable2(:,end-1)*10^maximg + finTable2(:,end);

       [~,idx1,idx2] = intersect(fieldcell1, fieldcell2);

       nanmean(abs(finTable1(idx1,:) - finTable2(idx2,:))./abs(finTable1(idx1,:) + finTable2(idx2,:))/2, 1)
       nanstd(abs(finTable1(idx1,:) - finTable2(idx2,:))./abs(finTable1(idx1,:) + finTable2(idx2,:))/2, 0, 1)
end




close all
clear all

%w2 = [1,1,1,1,1,1,1,0,0,0,0,0,0];
w2 = [0,0,0,0,1,1,1,1,1,0,0,0,0];


%subfolder = 2;
subfolder = 3;

h = figure;
c = 0;
finTable_all = [];
celllabels = [];
keys = [];
titles = [{'A431, number of microtubules'},{'A431, mean length of microtubule'},{'A431, collinearity'},...
          {'U2OS, number of microtubules'},{'U2OS, mean length of microtubule'},{'U2OS, collinearity'},...
          {'U251MG, number of microtubules'},{'U251MG, mean length of microtubule'},{'U251MG, collinearity'}];
xlabels = [{'number of microtubules'},{'mean length of microtubule'},{'collinearity'}];
for setno = 1:3
	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w2(1,:)),'  ','_'),'.mat'],'finTable');

       keys = [keys; double(finTable(:,[end-2:end]))];
       finTable = double(finTable(:,[1,2,4]));  %%
       finTable_all = [finTable_all; finTable];
       celllabels = [celllabels; setno*ones(size(finTable,1),1)];
       for dd = 1:3
           c = c + 1;
           subplot(3, 3, c); 
           [n,xout] = hist(finTable(:,dd),unique(finTable(:,dd))); 
           bar(xout,n/sum(n)); %relative frequency is n/sum(n)
           title(titles{c});
           xlabel(xlabels{dd}); ylabel('Relative frequency');
       end     
end

saveas(h,'hist_real.fig');
saveas(h,'hist_real.jpg');

[d,p,stats] = manova1(finTable_all,celllabels);

p_all = zeros(3,1);
table_all = cell(3,1);
stats_all = cell(3,1);
for dd = 1:3
    [p_all(dd),table_all{dd},stats_all{dd}] = anova1(finTable_all(:,dd), celllabels);
end


% plot
gmean = grpstats(finTable_all, keys(:,1), 'mean');
gstd = grpstats(finTable_all, keys(:,1), 'std');
CellLines = [{'A431'},{'U2OS'},{'U251MG'}];
markers = [{'sr'},{'og'},{'*b'}];
h1 = figure; 
subplot(1,2,1);
hold on;
for i = 1:length(CellLines)
    plot(gmean(i,2), gmean(i,1), markers{i});
    text(gmean(i,2), gmean(i,1), CellLines{i});

    idx = keys(:,1)==i;
    mu = mean(finTable_all(idx,2:-1:1),1)';
    sigma = cov(finTable_all(idx,2:-1:1));
    plotellipse(mu,sigma,markers{i}(end));
end
title('3 cell lines'); %legend(CellLines,'Location','SouthEast');
xlabel('mean length of microtubule'); ylabel('number of microtubules');
hold off;

subplot(1,2,2);
hold on;
for i = 1:length(CellLines)
    plot(gmean(i,2), gmean(i,1), markers{i});
    text(gmean(i,2), gmean(i,1), CellLines{i});

    idx = keys(:,1)==i;
    plot(finTable_all(idx,2), finTable_all(idx,1), markers{i});
end
title('3 cell lines'); %legend(CellLines,'Location','SouthEast');
xlabel('mean length of microtubule'); ylabel('number of microtubules');
hold off;
saveas(h1, 'wrap_3_Celllines.fig');
saveas(h1, 'wrap_3_Celllines.png');


%save show_real_results.mat -v4
%save show_real_results_s3_w7.mat -v4
save show_real_results_s3_w5.mat -v4




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all

w = [1,1,1,1,1,1,1,0,0,0,0,0,0];
%w = [0,0,0,0,1,1,1,1,1,0,0,0,0];

%subfolder = 2;
subfolder = 3;

finTable_all = [];
for setno = 1:3
	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w),'  ','_'),'.mat'],'finTable');
	finTable_all = [finTable_all; double(finTable)];
end
clear finTable

realfilenames = 'allrealfeats_usedforsim_w7.mat';
%realfilenames = 'allrealfeats_usedforsim_w5.mat';
load(realfilenames);


fin_mat_all = [double(finTable_all(:,[end-2:end])), double(finTable_all(:,[1:5])), fin_mat_all];

addpath('/home/jieyuel/lib_backup/lib_Justin/lib/classification'); % splitbyproteins

batchno_all = zeros(size(fin_mat_all,1), 1);  %%
for setno = 1:3
    Ninit = 5;
    idx = fin_mat_all(:,1)==setno; ind = find(idx);  %%
    [trainidx, testidx, protlabels, N] = splitbyproteins( ones(sum(idx),1), 1:sum(idx), Ninit);
    for i = 1:N
        testind = find(ismember(protlabels,testidx{i}));
        batchno_all(ind(testind)) = i;
    end
end


save(['./real_allfeatures_w',num2str(sum(w)),'_s',num2str(subfolder),'.mat'],'-v4');  %%  

