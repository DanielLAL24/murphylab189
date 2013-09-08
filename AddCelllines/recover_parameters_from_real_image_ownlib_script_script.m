clear all
close all

load HPAimagelist2.mat AddCellLines celllabels 

%w = [1;1;1;1;1;1;1];
w = [1,1,1,1,1,1,1,0,0,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,1,1,1
     0,0,0,0,1,1,1,1,1,1,1,1,1
     1,1,1,1,1,1,1,1,1,1,1,1,1];

for i = 1:size(w,1)
for setno = unique(celllabels)'
%for setno = 11
	recover_parameters_from_real_image_ownlib_script(setno,w(i,:));
end
end
