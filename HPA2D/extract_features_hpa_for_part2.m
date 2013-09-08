function extract_features_hpa_for_part2(subfolder,cellnum,setno,fieldno,batchno,n_inputArray,mulen_inputArray,colli_inputArray,coeff_var_Array,thr)

%thr = 6;

myfile = ['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(cellnum) '/final_info.mat'];

tmpfolder = './tmp/';
if ~exist(tmpfolder,'dir')
   mkdir(tmpfolder);
end

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

  %for thr = 6:8
    for n = n_inputArray
	for mu_len = mulen_inputArray
		for coeff_var = coeff_var_Array
			sigma_len = coeff_var*mu_len;
			for colli_min_number = colli_inputArray
				myfile = ['outputs_' num2str(subfolder) '/images/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/thr_' num2str(thr) '/Image_' num2str(cellnum) '/batch_' num2str(batchno) '/new_n_' num2str(n) '/new_sim_n_' num2str(n) '_mulen_' num2str(mu_len) '_siglen_' num2str(sigma_len) '_colli_' num2str(colli_min_number) '.mat'];
				if (exist(myfile,'file') == 2)
				    for rad = [240]
					[G_psf] = getsynimage_hpa(n,mu_len,sigma_len,colli_min_number,cellnum,batchno,setno,fieldno,subfolder,rad,thr);  %%used for calculating features
				 
                                   featfolder = ['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/'];
                                   if ~exist(featfolder,'dir')
                                      mkdir(featfolder);
                                   end
					for J = 1:length(featTypeList)
                                       %savefile = ['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '_thr_' num2str(thr) '_n_' num2str(n) '_mulen_' num2str(mu_len) '_siglen_' num2str(sigma_len) '_colli_' num2str(colli_min_number) '.mat'];
                                       savefile = ['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '_thr_' num2str(thr) '_n_' num2str(n) '_mulen_' num2str(mu_len) '_siglen_' num2str(sigma_len) '_colli_' num2str(colli_min_number) '_' featTypeList{J} '.mat'];
                                       tmpfile = [tmpfolder,regexprep(savefile,'/','_'),'.txt'];
         				    if ~exist(tmpfile,'file')
                                          fid = fopen(tmpfile,'w');
                                          %if exist(savefile,'file')
						%   try
						%	load(savefile);
						%   catch
						%	delete(savefile);
						%   end
						%end
                                          if ~exist(savefile,'file')
					%[G_psf] = getsynimage_hpa(n,mu_len,sigma_len,colli_min_number,cellnum,batchno,setno,fieldno,subfolder,rad,thr);  %%used for checking after feature calculation
					          feat_vector = [];
						   feat_vector = [feat_vector,feat_extract_hpa(G_psf(:,:,4),[],featTypeList{J},imgcent_coordinate(1:2),setno,fieldno,cellnum)];
					       
					          fin_mat(I,:) = [n mu_len sigma_len colli_min_number thr feat_vector];
           					   save(savefile, 'fin_mat');
                              		end
                                          try
                                          fclose(fid);
       					delete(tmpfile);  %%
                                          catch
						warning('Invalid file identifier.  Use fopen to generate a valid file identifier.');
						end
     					    end
                                       fin_mat = [];
  					    I = 1;  %%
					end
					%I = I + 1  %%
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
  %end

%  mkdir(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/']);

%  save(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '.mat'],'fin_mat');

else
  error('No real image!');

end % end of if

end % end of function
