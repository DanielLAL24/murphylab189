%function extract_features(setno,fieldno)
function extract_features(setno,fieldno,cellnum,batchno)

rand_start = 1;

if ~exist('batchno','var')
batchno = 1;
end

%subfolder = 1;  %%Aabid, Gaussian: /home/ashariff/work52/outputs_1/images/
%subfolder = 2;  %%Jieyue, Erlang, one-step rebound control
subfolder = 3;  %%Jieyue, Erlang, multi-steps rebound control

%n_inputArray = [5,50:50:350];
%mulen_inputArray  = [5 10 15 20 25 30 35];
%n_inputArray = [5,50:50:350,400];
%mulen_inputArray  = [5 10 15 20 25 30 35 40];
n_inputArray = [5,50:50:350,400,450];
mulen_inputArray  = [5 10 15 20 25 30 35 40 45]; 
colli_inputArray = collinearityrange(5,0.97);
colli_inputArray(:,[3,5]) = [];

if subfolder == 1  %%
coeff_var_Array = [0.1 0.2 0.3];
else
coeff_var_Array = 0;
end

for thr = 6:8
       if ~exist('cellnum','var')
          imagefolders = dir(['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_*']);
	else
          imagefolders(1).name = ['Image_' num2str(cellnum)];  %%
	end
	for i = 1:length(imagefolders)
	    imnum = str2num(imagefolders(i).name(7:end));
	    extract_features_hpa_for_part2(subfolder,imnum,setno,fieldno,batchno,n_inputArray,mulen_inputArray,colli_inputArray,coeff_var_Array,thr);
	end
end

end % End of function

