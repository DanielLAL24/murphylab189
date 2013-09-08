function extract_features_hpa_for_part2(subfolder,cellnum,batchno,n_inputArray,mulen_inputArray,colli_inputArray,coeff_var_Array)

%setgenpath
imCategory = 'general';

featTypeList{1} = 'haralick';
featTypeList{2} = 'histpropwithcent';
featTypeList{3} = 'harkd2';
featTypeList{4} = 'harkd4';
featTypeList{5} = 'totint';
featTypeList{6} = 'radIntensity';
featTypeList{7} = 'edge';

  featTypeList{8} = 'haralick2';
  featTypeList{9} = 'histpropwithcent2';
  featTypeList{10} = 'histbinwithcent2';
  featTypeList{11} = 'histDistLevel2';
  featTypeList{12} = 'statDistLevel';
  featTypeList{13} = 'distHist';

%subfolder = 1;
featType = 'all';

fin_mat = [];
I = 1;

tmpfolder = './tmp/';
if ~exist(tmpfolder,'dir')
   mkdir(tmpfolder);
end

savefile = ['outputs_' num2str(subfolder) '/featvals/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '.mat'];
tmpfile = [tmpfolder,regexprep(savefile,'/','_'),'.txt'];
if ~exist(tmpfile,'file')
   fid = fopen(tmpfile,'w');
   if ~exist(savefile,'file')

for thr = 6:8
for n = n_inputArray
	for mu_len = mulen_inputArray
		for coeff_var = coeff_var_Array
			sigma_len = coeff_var*mu_len;
			for colli_min_number = colli_inputArray
				myfile = ['outputs_' num2str(subfolder) '/images/thr_' num2str(thr) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/new_n_' num2str(n) '/new_sim_n_' num2str(n) '_mulen_' num2str(mu_len) '_siglen_' num2str(sigma_len) '_colli_' num2str(colli_min_number) '.mat'];

				if (exist(myfile,'file') == 2)
				 
					[G_psf,imgcent_coordinate] = getsynimage_hela(n,mu_len,sigma_len,colli_min_number,cellnum,batchno,subfolder,thr);
				 
					feat_vector = [];
					%for J = 1:7
					for J = 1:13
						feat_vector = [feat_vector,feat_extract(G_psf(:,:,4),[],featTypeList{J},imgcent_coordinate(1:2),cellnum,thr)];
					end
					fin_mat(I,:) = [n mu_len sigma_len colli_min_number thr feat_vector];
					I = I + 1   %%
				else
                              if (exist([myfile(1:end-4),'-tcheck.mat'],'file') == 2)
                                  warning('This image cannot be generated.');
       			  else
                                  error('No synthetic image for feature calculation!');
				  end
				end
			end
		end
	end
end
end

if ~exist(['outputs_' num2str(subfolder) '/featvals/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/'],'dir')
mkdir(['outputs_' num2str(subfolder) '/featvals/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/']);
end

save(['outputs_' num2str(subfolder) '/featvals/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '.mat'],'fin_mat');

end % end of savefile
try
fclose(fid);
delete(tmpfile);
catch
end
end % end of tmpfile

end % end of function
