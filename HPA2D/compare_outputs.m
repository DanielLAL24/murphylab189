% compare outputs

close all
clear all

subfolder = [2,3];

w = [1,1,1,1,1,1,1,0,0,0,0,0,0];
%w = [0,0,0,0,1,1,1,1,1,0,0,0,0];

finTable_all = [];
for i = 1:length(subfolder)
for setno = 1:3
	load(['./outputs_',num2str(subfolder(i)),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w),'  ','_'),'.mat'],'finTable');
	finTable_all = [finTable_all; double(finTable)];
end
end


save compare_outputs.mat

[aa1,bb1] = hist(finTable_all(1:size(finTable_all,1)/length(subfolder),6),20);
[aa2,bb2] = hist(finTable_all(size(finTable_all,1)/length(subfolder)+1:size(finTable_all,1),6),20);
figure;
plot(bb1,aa1/sum(aa1),'r-o');
hold on;
plot(bb2,aa2/sum(aa2),'b-o');
legend('without multi-step control','with multi-step control');
xlabel('Matched Mahalanobis distance'); ylabel('Frequency');
