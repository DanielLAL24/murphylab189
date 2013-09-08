clear all
close all

w = [1,1,1,1,1,1,1,0,0,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,1,1,1
     0,0,0,0,1,1,1,1,1,1,1,1,1
     1,1,1,1,1,1,1,1,1,1,1,1,1];


%subfolder = 2;
subfolder = 3;

%load(['./real_allfeatures_w',num2str(7),'_s',num2str(subfolder),'_11line.mat'],'batchno_all','fin_mat_all');
load(['./real_allfeatures_w',num2str(7),'_s',num2str(subfolder),'_11line2.mat'],'batchno_all','fin_mat_all','keepidx');
allss = fin_mat_all(:,1);
clear fin_mat_all  

rand_start = [3,7,11,13,17,19,23,29,31,37];

rand_errs = zeros(length(unique(allss)), 3, size(w,1), length(rand_start));

for i = 1:size(w,1)
finTable_all = [];
for setno = unique(allss')
       if (setno<=3) && (setno>=1)
	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w(i,:)),'  ','_'),'.mat'],'finTable');
       else
	load(['../AddCelllines/outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w(i,:)),'  ','_'),'.mat'],'finTable');
       end
       finTable_all = [finTable_all; finTable];
end
if exist('keepidx','var')
   finTable_all = finTable_all(keepidx,:);
end

for setno = unique(allss')
	idx = finTable_all(:,7)==setno;
       finTable = finTable_all(idx,:);
	for j = 1:length(rand_start)
		rand('seed',rand_start(j)); randn('seed',rand_start(j));

		n_randsample = zeros(size(finTable,1),1);
		mulen_randsample = zeros(size(finTable,1),1);
		colli_randsample = zeros(size(finTable,1),1);
		for k = unique(batchno_all(allss==setno))'
		testind = batchno_all(allss==setno)==k;
		[nf, n_inputArray] = hist(finTable(~testind,1), unique(finTable(~testind,1)));
		[muf, mulen_inputArray] = hist(finTable(~testind,2), unique(finTable(~testind,2)));
		[cof, colli_inputArray] = hist(finTable(~testind,4), unique(finTable(~testind,4))); if isempty(cof) continue; end

		samples = mnrnd(1,nf/sum(nf),sum(testind));
		[r,c] = find(samples==1);
		[r,idx] = sort(r,'ascend');
		c = c(idx);
		n_randsample(testind) = n_inputArray(c);

		samples = mnrnd(1,muf/sum(muf),sum(testind));
		[r,c] = find(samples==1);
		[r,idx] = sort(r,'ascend');
		c = c(idx);
		mulen_randsample(testind) = mulen_inputArray(c);

		samples = mnrnd(1,cof/sum(cof),sum(testind));
		[r,c] = find(samples==1);
		[r,idx] = sort(r,'ascend');
		c = c(idx);
		colli_randsample(testind) = colli_inputArray(c);
		end
		rand_errs(setno, 1, i, j) = mean(abs(n_randsample(:)-finTable(:,1))./finTable(:,1)) * 100;
		rand_errs(setno, 2, i, j) = mean(abs(mulen_randsample(:)-finTable(:,2))./finTable(:,2)) * 100;
		rand_errs(setno, 3, i, j) = mean(abs(colli_randsample(:)-finTable(:,4))./finTable(:,4)) * 100;

	end
end
end


rand_errs_all = zeros(1, 3, size(w,1), length(rand_start));

allss = ones(length(allss),1);
for i = 1:size(w,1)
finTable_all = [];
for setno = 1:11  %%
       if (setno<=3) && (setno>=1)
	load(['./outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w(i,:)),'  ','_'),'.mat'],'finTable');
       else
	load(['../AddCelllines/outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w(i,:)),'  ','_'),'.mat'],'finTable');
       end
	finTable_all = [finTable_all; finTable];
end
finTable = finTable_all; clear finTable_all
if exist('keepidx','var')
   finTable = finTable(keepidx,:);
end
setno = 1;

	for j = 1:length(rand_start)
		rand('seed',rand_start(j)); randn('seed',rand_start(j));

		n_randsample = zeros(size(finTable,1),1);
		mulen_randsample = zeros(size(finTable,1),1);
		colli_randsample = zeros(size(finTable,1),1);
		for k = unique(batchno_all(allss==setno))'
		testind = batchno_all(allss==setno)==k;
		[nf, n_inputArray] = hist(finTable(~testind,1), unique(finTable(~testind,1)));
		[muf, mulen_inputArray]  = hist(finTable(~testind,2), unique(finTable(~testind,2)));
		[cof, colli_inputArray] = hist(finTable(~testind,4), unique(finTable(~testind,4)));

		samples = mnrnd(1,nf/sum(nf),sum(testind));
		[r,c] = find(samples==1);
		[r,idx] = sort(r,'ascend');
		c = c(idx);
		n_randsample(testind) = n_inputArray(c);

		samples = mnrnd(1,muf/sum(muf),sum(testind));
		[r,c] = find(samples==1);
		[r,idx] = sort(r,'ascend');
		c = c(idx);
		mulen_randsample(testind) = mulen_inputArray(c);

		samples = mnrnd(1,cof/sum(cof),sum(testind));
		[r,c] = find(samples==1);
		[r,idx] = sort(r,'ascend');
		c = c(idx);
		colli_randsample(testind) = colli_inputArray(c);
		end
		rand_errs_all(setno, 1, i, j) = mean(abs(n_randsample(:)-finTable(:,1))./finTable(:,1)) * 100;
		rand_errs_all(setno, 2, i, j) = mean(abs(mulen_randsample(:)-finTable(:,2))./finTable(:,2)) * 100;
		rand_errs_all(setno, 3, i, j) = mean(abs(colli_randsample(:)-finTable(:,4))./finTable(:,4)) * 100;

	end
end

%save real_random_11line.mat
save real_random_11line2.mat
