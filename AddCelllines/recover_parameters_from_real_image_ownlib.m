function [finTable] = recover_parameters_from_real_image_ownlib(subfolder,setno,batchno,fieldno,cellnum,w)

imCategory = 'general';
featType = 'all';


load(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '.mat'],'fin_mat');
feat_vector_MI = fin_mat(:,[6:end]);  %%

%subfolder= 1;
%w = [1;1;1;1;1;1;1];
distmet = 'nvar';


load allrealfeats_allfeats_allsets all_feat_vector2 idxes % This is only for general, but shud be ok for nocent

ffidx = [];
%for I = 1:7
for I = 1:length(w)
	if w(I) == 1
		ffidx = [ffidx,idxes{I}(1):idxes{I}(2)];
	end
end

feat_vector = all_feat_vector2(:,ffidx);
feat_vector_MI = feat_vector_MI(:,ffidx);  %%
idxremove =  find(sum(abs(feat_vector),1)==0);


if batchno < 2  %% recover for the real images
[image,A,B,imgcent_coordinate] = getrealimage_hpa(setno,fieldno,cellnum);
feat_vector_ori = real_im_feat_extract(image,imgcent_coordinate,w,setno,fieldno,cellnum);
else            %% recover for the synthetic images in batchno==1
query_batchno = 1;  %%
data = load(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(query_batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(query_batchno) '.mat'],'fin_mat');
feat_vector_ori = data.fin_mat(:,[6:end]);  %%
feat_vector_ori = feat_vector_ori(:,ffidx);
idxremove =  find(sum(abs(feat_vector_MI),1)==0);
end


% compute distances and pick the global minimum

% corrections

feat_vector(:,idxremove) = [];
feat_vector_MI(:,idxremove) = [];
feat_vector_ori(:,idxremove) = [];


if batchno < 2  %% recover for the real images
varmat = var(feat_vector);
else            %% recover for the synthetic images in batchno==1
varmat = var(feat_vector_MI);
end

finTable = [];
for S = 1:size(feat_vector_ori,1)
for T = 1:size(fin_mat,1)
	mahdist(S,T) = nvardist_extract(feat_vector_MI(T,:),feat_vector_ori(S,:),varmat);
end

[I,J] = min(mahdist(S,:));
		
finTable = [finTable; [fin_mat(J,1:5), I]];
end		

end % End of function
