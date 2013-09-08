clear all
close all

w = [1,1,1,1,1,1,1,0,0,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,1,1,1
     0,0,0,0,1,1,1,1,1,1,1,1,1
     1,1,1,1,1,1,1,1,1,1,1,1,1];

cellnums =  [1 2 4 6 10 12:42 46:49 51:52]
K = 1;

%subfolder = 1;
%subfolder = 2;
subfolder = 3;  %%

featType = 'all';
imCategory = 'general';
batchno = 1;
% w = [1;1;1;1;1;0;0];

for i = 1:size(w,1)
finTable = [];
K = 1;
for cellnum = cellnums
       disp([num2str(w(i,:)),' cell ',num2str([cellnum])])
	finTable(K,:) = [recover_parameters_from_real_image_ownlib(subfolder,batchno,cellnum,w(i,:)),cellnum];
	K = K + 1;
end

%mkdir(['outputs_' num2str(subfolder) '/results/w_' num2str(w(1)) '_' num2str(w(2)) '_' num2str(w(3)) '_' num2str(w(4)) '_' num2str(w(5)) '_' num2str(w(6)) '_' num2str(w(7))])
%save(['outputs_' num2str(subfolder) '/results/w_' num2str(w(1)) '_' num2str(w(2)) '_' num2str(w(3)) '_' num2str(w(4)) '_' num2str(w(5)) '_' num2str(w(6)) '_' num2str(w(7)) '/result_new.mat']);
if ~exist(['outputs_' num2str(subfolder) '/results/w_' regexprep(num2str(w(i,:)),'  ','_')],'dir')
   mkdir(['outputs_' num2str(subfolder) '/results/w_' regexprep(num2str(w(i,:)),'  ','_')]);
end
save(['outputs_' num2str(subfolder) '/results/w_' regexprep(num2str(w(i,:)),'  ','_') '/result_new.mat']);

end
