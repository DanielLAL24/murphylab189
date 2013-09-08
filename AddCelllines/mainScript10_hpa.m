function mainScript10_hpa(rand_start,batchno,setno,fieldno,imnum,subfolder,n_inputArray,mulen_inputArray,colli_inputArray,coeff_var_Array,thr)

myfile = ['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(imnum) '/final_info.mat'];

tmpfolder = './tmp/';
if ~exist(tmpfolder,'dir')
   mkdir(tmpfolder);
end

if (exist(myfile,'file') == 2)
	
	load(myfile,'Dbothfin','imgcent_coordinate','XYZres','segdna');

%	n_inputArray = [5,50:50:500];
%	mulen_inputArray  = [1 3 5 7 10 12 15 17 20 22 25 27 30 35];
%	colli_inputArray = collinearityrange(5,0.97);
%	coeff_var_Array = [0 0.1 0.2 0.3];

	rand_seed = ((batchno-1)*100000)+rand_start;
	XYZres = [0.2 0.2 0.2];


	for n = n_inputArray
		folderName = ['outputs_' num2str(subfolder) '/images/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/thr_' num2str(thr) '/Image_' num2str(imnum) '/batch_' num2str(batchno) '/new_n_' num2str(n)];
              if ~exist(folderName,'dir')
		   mkdir(folderName);
              end
		tcheckflag = false;
		for mu_len = mulen_inputArray
			for coeff_var = coeff_var_Array
                       		sigma_len = coeff_var*mu_len;
				for colli_min_number = colli_inputArray
					myfile2 = ['outputs_' num2str(subfolder) '/images/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/thr_' num2str(thr) '/Image_' num2str(imnum) '/batch_' num2str(batchno) '/new_n_' num2str(n) '/new_sim_n_' num2str(n) '_mulen_' num2str(mu_len) '_siglen_' num2str(sigma_len) '_colli_' num2str(colli_min_number) '.mat'];
                                   tmpfile = [tmpfolder,regexprep(myfile2,'/','_'),'.txt'];  %%
                                   if ~exist(tmpfile,'file')                                      
                                   fid = fopen(tmpfile,'w');
					if (exist(myfile2,'file')~=2) && (exist([myfile2(1:end-4),'-tcheck.mat'],'file')~=2)
					   if subfolder<=2
					   [K,tcheck] = colli_generator_acute(n,mu_len,sigma_len,colli_min_number,Dbothfin,imgcent_coordinate,XYZres,0.3,XYZres(1),rand_seed,imnum,setno,fieldno,subfolder,batchno,thr);
					   else
					   [K,tcheck] = colli_generator_acute_jl2(n,mu_len,sigma_len,colli_min_number,Dbothfin,imgcent_coordinate,XYZres,0.3,XYZres(1),rand_seed,imnum,setno,fieldno,subfolder,batchno,thr);
					   end
					end % end of myfile2
					try             %%
                                   fclose(fid);
    					delete(tmpfile);
					catch
					end		  %end of try
                                   end % end of tmpfile
					rand_seed = rand_seed + 1;
				end % end of colli for
			end % end of coeff for
		end % end of mulen for
	end % end of n for
else
    error('No original proc image!');
end % End of if

end % end of function
