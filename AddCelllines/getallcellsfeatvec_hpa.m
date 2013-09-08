clear all
close all

%addpath(genpath('/home/jieyuel/lib_backup/3CellLine/tarball/HPA2D/slicfiles'));

load HPAimagelist2.mat AddCellLines celllabels 

%w = [1;1;1;1;1;1;1];
w = [1;1;1;1;1;1;1;1;1;1;1;1;1];
imCategory = 'general';

cellnums = [1:50];

I = 1;
for setno = unique(celllabels)'
       fieldnos = 1:sum(celllabels==setno);
	for fieldno = fieldnos
		for imnum = cellnums
			myfile = ['proc_6/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(imnum) '/final_info.mat'];
			if (exist(myfile,'file') == 2)
				[protim3,Dbothfin,segdna,imgcent_coordinate] = getrealimage_hpa(setno,fieldno,imnum);
 				[all_feat_vector2(I,:),idxes] = getfeatvector_hpa(protim3,imgcent_coordinate,imCategory,w,setno,fieldno,imnum);
				keys(I,:) = [setno fieldno imnum];
        			I = I + 1
			end
		end
	end
end

save allrealfeats_allfeats_allsets all_feat_vector2 idxes keys


load allrealfeats_allfeats_allsets 

w = [1,1,1,1,1,1,1,0,0,0,0,0,0];
%w = [0,0,0,0,1,1,1,1,1,0,0,0,0];

ffidx = [];
for I = 1:length(w)
	if w(I) == 1
		ffidx = [ffidx,idxes{I}(1):idxes{I}(2)];
	end
end

fin_mat_all = double(all_feat_vector2(:, ffidx));

save allrealfeats_allfeats_allsetsw7 fin_mat_all idxes keys -v4
%save allrealfeats_allfeats_allsetsw5 fin_mat_all idxes keys -v4
