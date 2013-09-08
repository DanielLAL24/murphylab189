clear all
close all

for thr = 6:8
   for imnum = [1 2 4 6 10 12:42 46:49 51:52]
	load(['../HeLa3D/proc/cell_' num2str(imnum) '/cell' num2str(imnum) '.mat'],'protim3','cellim3','dnaim3');
	%load(['/home/jieyuel/lib_backup/Microtubules/proc/cell_' num2str(imnum) '/cell' num2str(imnum) '.mat'],'protim3','cellim3','dnaim3');
	mfs = floor(size(protim3,3)/2);
	protim3 = protim3(:,:,mfs);
	cellim3 = cellim3(:,:,mfs);
	dnaim3 = dnaim3(:,:,mfs);

	tempsegdna2 = nuc_structure_det(dnaim3);
	segcell = binswitch(cell_structure_det(cellim3));
	segdna2 = zeros(size(segcell));
	segdna2(:,:,2:7) = tempsegdna2;
	segdna2(:,:,thr:7) = [];
	segcell(:,:,thr:7) = [];
	Dbothfin = double(logical(segcell + segdna2));
	segdnatemp = segdna2;	
	% add centrosome detect here
	imgcent_coordinate = esti_cent(binswitch(segcell),segdna2,protim3);
	if imgcent_coordinate(3) > thr
		imgcent_coordinate(3) = thr;
	end
	segdna = segdna2;
	mkdir(['proc_' num2str(thr) '/cell_' num2str(imnum)]);
	save(['proc_' num2str(thr) '/cell_' num2str(imnum) '/final_info.mat'],'Dbothfin','imgcent_coordinate','segdna','protim3');
   end
end
