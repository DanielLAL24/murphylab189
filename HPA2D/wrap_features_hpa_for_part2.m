function fin_mat = wrap_features_hpa_for_part2(subfolder,cellnum,setno,fieldno,batchno,n_inputArray,mulen_inputArray,colli_inputArray,coeff_var_Array)

fin_mat = -1; %%

thr = 6;
myfile = ['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(cellnum) '/final_info.mat'];

if (exist(myfile,'file') == 2)

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

  [protim3,Dbothfin,segdna,imgcent_coordinate] = getrealimage_hpa(setno,fieldno,cellnum);

  for thr = 6:8
    for n = n_inputArray
	for mu_len = mulen_inputArray
		for coeff_var = coeff_var_Array
			sigma_len = coeff_var*mu_len;
			for colli_min_number = colli_inputArray
				myfile = ['outputs_' num2str(subfolder) '/images/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/thr_' num2str(thr) '/Image_' num2str(cellnum) '/batch_' num2str(batchno) '/new_n_' num2str(n) '/new_sim_n_' num2str(n) '_mulen_' num2str(mu_len) '_siglen_' num2str(sigma_len) '_colli_' num2str(colli_min_number) '.mat'];
				if (exist(myfile,'file') == 2)
				    for rad = [240]
				 
                                   tmpfeat = [];
					for J = 1
                                       savefile = ['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '_thr_' num2str(thr) '_n_' num2str(n) '_mulen_' num2str(mu_len) '_siglen_' num2str(sigma_len) '_colli_' num2str(colli_min_number) '_' featTypeList{J} '.mat'];
					    data = load(savefile);   
					    tmpfeat = [tmpfeat, data.fin_mat];
                                   end
					for J = 2:length(featTypeList)
                                       savefile = ['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '_thr_' num2str(thr) '_n_' num2str(n) '_mulen_' num2str(mu_len) '_siglen_' num2str(sigma_len) '_colli_' num2str(colli_min_number) '_' featTypeList{J} '.mat'];
					    data = load(savefile);   
					    tmpfeat = [tmpfeat, data.fin_mat(6:end)];  %%
                                   end
                                   fin_mat(I,:) = tmpfeat;
					I = I + 1;
				    end
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

%  mkdir(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/']);

%  save(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '.mat'],'fin_mat');

end % end of if

end % end of function
