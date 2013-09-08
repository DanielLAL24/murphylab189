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
for setno = 4:11
	load(['../AddCelllines/outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w),'  ','_'),'.mat'],'finTable');
	finTable_all = [finTable_all; double(finTable)];
end
clear finTable


fin_mat_all = []; keys = [];
realfilenames = 'allrealfeats_usedforsim_w7.mat';
%realfilenames = 'allrealfeats_usedforsim_w5.mat';
data = load(realfilenames);
fin_mat_all = [fin_mat_all; data.fin_mat_all];
keys = [keys; data.keys];

realfilenames2 = '../AddCelllines/allrealfeats_allfeats_allsetsw7.mat';
data = load(realfilenames2);
idx = sum(abs(data.keys - repmat([10,1,4],[size(data.keys,1),1])),2); idx = find(idx==0);  %%
data.fin_mat_all(idx,:) = []; data.keys(idx,:) = [];
fin_mat_all = [fin_mat_all; data.fin_mat_all];
keys = [keys; data.keys];
clear data


fin_mat_all = [double(finTable_all(:,[end-2:end])), double(finTable_all(:,[1:5])), fin_mat_all];



save(['./real_allfeatures_w',num2str(sum(w)),'_s',num2str(subfolder),'_11line.mat'],'-v6');  %%  


load real_allfeatures_w7_s3_11line.mat
mahdist = finTable_all(:,6); keepidx = find(mahdist<=mean(mahdist)+std(mahdist));

finTable_all = finTable_all(keepidx,:);
fin_mat_all = fin_mat_all(keepidx,:);


keys = keys(keepidx,:);

for setno = 1:11
    CoefV(setno,:) = std(finTable_all(keys(:,1)==setno,:),[],1)./mean(finTable_all(keys(:,1)==setno,:),1);
end


save real_allfeatures_w7_s3_11line2.mat



