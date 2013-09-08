function [flag] = recover_parameters_from_real_image_ownlib_script(setno,w,fieldnos,cellnums,batchno)

if ~exist('cellnums','var')
cellnums = [1:50];
end
if ~exist('fieldnos','var')
fieldnos = [1:50];
end

K = 1;

%subfolder = 1;
%subfolder = 2;
subfolder = 3;

featType = 'all';
imCategory = 'general';

if ~exist('batchno','var')
batchno = 1;
end

finTable = [];
imcount = 0; thr = 6;  %%
for fieldno = fieldnos
%for cellnum = cellnums  %%for selecting a subset
%	if imcount>=10 break; end  %%for selecting a subset
	for cellnum = cellnums
%	for fieldno = fieldnos  %%for selecting a subset
%		if imcount>=10 break; end  %%for selecting a subset
		if ~exist(['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(cellnum)],'dir')  %%
			continue;
		end
%		imcount = imcount + 1;  %%for selecting a subset

		myfile = ['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '.mat'];

		if exist(myfile,'file')==2
			load(myfile,'fin_mat');
			if size(fin_mat,1)>0
				disp([num2str(w),' cell ',num2str([setno,fieldno,cellnum])])
				%finTable(K,:) = [recover_parameters_from_real_image_ownlib(subfolder,setno,batchno,fieldno,cellnum,w),setno,fieldno,cellnum];
				tmpfinTable = recover_parameters_from_real_image_ownlib(subfolder,setno,batchno,fieldno,cellnum,w);
				finTable = [finTable; [tmpfinTable,repmat([setno,fieldno,cellnum],[size(tmpfinTable,1),1])]];
				K = K + 1;
			end
		end
	end
end
[tmp,index] = sortrows(finTable(:,[end-2:end]));  %%
finTable = finTable(index,:);  %%

if batchno < 2  %% recover for the real images
if ~exist(['outputs_' num2str(subfolder) '/results/set_' num2str(setno) '/'],'dir')
   mkdir(['outputs_' num2str(subfolder) '/results/set_' num2str(setno) '/']);
end
%save(['outputs_' num2str(subfolder) '/results/set_' num2str(setno) '/result_new.mat']);
save(['outputs_' num2str(subfolder) '/results/set_' num2str(setno) '/result_new_' regexprep(num2str(w),'  ','_') '.mat']);
else            %% recover for the synthetic images in batchno==1
if ~exist(['outputs_' num2str(subfolder) '/results/set_' num2str(setno) '/' 'fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/'],'dir')
   mkdir(['outputs_' num2str(subfolder) '/results/set_' num2str(setno) '/' 'fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/']);
end
save(['outputs_' num2str(subfolder) '/results/set_' num2str(setno) '/' 'fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/result_new_' regexprep(num2str(w),'  ','_') '.mat']);
end
