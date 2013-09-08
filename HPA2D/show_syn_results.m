close all
clear all

if exist('show_syn_results_s3.mat','file')
   load show_syn_results_s3.mat
else
% show synthetic experiment results

w = [0,0,0,0,1,1,1,1,1,0,0,0,0];
%w = [1,1,1,1,1,1,1,0,0,0,0,0,0
%     0,0,0,0,1,1,1,1,1,0,0,0,0
%     0,0,0,0,1,1,1,1,1,0,1,1,1
%     0,0,0,0,1,1,1,1,1,1,1,1,1
%     1,1,1,1,1,1,1,1,1,1,1,1,1];

imCategory = 'general';
featType = 'all';

%subfolder = 2;  %%
subfolder = 3;  %%

setno = 3; fieldno = 7; cellnum = 1;

batchnos = 2:6;

query_batchno = 1;  %%
%load(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(query_batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(query_batchno) '.mat'],'fin_mat');
load show_syn_results_s3~.mat fin_mat
finTable1 = fin_mat(:,1:5);

diff_finTable_batch = cell(size(w,1),1);
for i = 1:size(w,1)
for batchno = batchnos
    disp([batchno,w(i,:)])
    load(['outputs_' num2str(subfolder) '/results~400,40~Used_in_draft_ISMB2012/set_' num2str(setno) '/' 'fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/result_new_' regexprep(num2str(w(i,:)),'  ','_') '.mat'],'finTable');
    %nanmean(abs(finTable(:,1:5) - finTable1)./finTable1,1)*100
    %nanstd(abs(finTable(:,1:5) - finTable1)./finTable1,0,1)*100
    diff_finTable_batch{i} = cat(3, diff_finTable_batch{i}, abs(finTable(:,1:5) - finTable1)./finTable1);
end
end

i = 1;
%nanmean(nanmean(abs(diff_finTable_batch{i}),3),1)
%nanmean(nanstd(abs(diff_finTable_batch{i}),0,3),1)
%i = 2;
%nanmean(nanmean(abs(diff_finTable_batch{i}),3),1)
%nanmean(nanstd(abs(diff_finTable_batch{i}),0,3),1)
%mean(diff_finTable_batch{2}(:,1,1))*100
%std(diff_finTable_batch{2}(:,1,1))*100
TableII_mu = nan(5,4);
TableII_sd = nan(5,4);
for j = [1,2,4]
for batchno = batchnos
    TableII_mu(batchno-1,j) = mean(diff_finTable_batch{i}(:,j,batchno-1))*100;
    TableII_sd(batchno-1,j) = std(diff_finTable_batch{i}(:,j,batchno-1))*100;
end
end

%save show_syn_results.mat
save show_syn_results_s3.mat
end
