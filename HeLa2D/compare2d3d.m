clear all
close all

if exist('compare2d3d.mat','file')
   load compare2d3d.mat
else
load ../HeLa3D/cell_height.mat Heights

%subfolder = 2;  % jl's Erlang model 
subfolder = 3;  % jl's Erlang model, multi-steps rebounding control 

%w = [1,1,1,1,1,1,1,0,0,0,0,0,0
%     0,0,0,0,1,1,1,1,1,0,0,0,0
%     0,0,0,0,1,1,1,1,1,0,1,1,1
%     0,0,0,0,1,1,1,1,1,1,1,1,1
%     1,1,1,1,1,1,1,1,1,1,1,1,1];
w = [1,1,1,1,1,1,1,1,1,1,1,1,1];

errs_mean = zeros(size(w,1),5);
errs_std = zeros(size(w,1),5);
for i = 1:size(w,1)

load(['outputs_' num2str(subfolder) '/results/w_' regexprep(num2str(w(i,:)),'  ','_') '/result_new.mat'],'finTable');

finTable2D = finTable;

load(['../HeLa3D/' 'outputs_' num2str(subfolder) '/results/result_new_' regexprep(num2str(w(i,:)),'  ','_') '.mat'],'finTable');

finTable3D = finTable;

%{
save compare2d3d.mat
ind1 = find(finTable3D(:,5)'>=(median(finTable3D(:,5)')+3*median(finTable3D(:,5)')));
%ind2 = find(finTable2D(:,6)'>=(median(finTable2D(:,6)')+median(finTable2D(:,6)')));
ind2 = [];
ind = unique([ind1(:);ind2(:)]);
finTable3D(ind,:) = [];
finTable2D(ind,:) = [];
%}

labels{1} = 'Number of Microtubules';
labels{2} = 'Mean of length';

%{
for I = 1:2
	figure
	[x,a] = hist(finTable3D(:,I),length(unique(finTable3D(:,I))));
	plot(a,x,'*-'), hold on
	[x,a] = hist(finTable2D(:,I),length(unique(finTable2D(:,I))));
	plot(a,x,'r*-')
	ylabel('Frequency')
	xlabel(labels{I});
	legend('3D','2D');
end
%}

errs_mean(i,:) = [100*nanmean(abs((finTable3D(:,1:4) - finTable2D(:,1:4))./(finTable3D(:,1:4)))),100*nanmean(abs((finTable2D(:,5) - Heights)./Heights))];
errs_std(i,:) = [100*nanstd(abs((finTable3D(:,1:4) - finTable2D(:,1:4))./(finTable3D(:,1:4)))),100*nanstd(abs((finTable2D(:,5) - Heights)./Heights))];
%keyboard
end

save compare2d3d.mat
end
