%function fin_mat_all = wrap_features(setno,fieldno)
function [flag,fin_mat_all] = wrap_features(setno,fieldno,maxnimgs,batchno)

rand_start = 1;

if ~exist('batchno','var')
batchno = 1;
end

%subfolder = 1;  %%Aabid, Gaussian: /home/ashariff/work52/outputs_1/images/
%subfolder = 2;  %%Jieyue, Erlang, one-step rebound control
subfolder = 3;  %%Jieyue, Erlang, multi-steps rebound control

%n_inputArray = [5,50:50:350,400];
%mulen_inputArray  = [5 10 15 20 25 30 35 40];
%n_inputArray = [5,50:50:350,400,450,500];  %% setno = 7
%mulen_inputArray  = [5 10 15 20 25 30 35 40 45 50];  %% setno = 7
n_inputArray = [5,50:50:350,400,450];
mulen_inputArray  = [5 10 15 20 25 30 35 40 45];
colli_inputArray = collinearityrange(5,0.97);
colli_inputArray(:,[3,5]) = [];

if subfolder == 1  %%
coeff_var_Array = [0.1 0.2 0.3];
else
coeff_var_Array = 0;
end

imCategory = 'general';
featType = 'all';

fin_mat_all = [];  %%

flag = 0;  thr = 6; %%
if ~exist('maxnimgs','var')
maxnimgs = 1:50;  %%
end
for imnum = maxnimgs
    cellnum = imnum;

    if ~exist(['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(imnum)],'dir')  %%
	continue;
    end
    flag = 1;  %%

    if nargout <= 1
    if exist(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '.mat'],'file')
       continue;  %%
    end
    end
    disp([setno,fieldno,cellnum]);
    fin_mat = wrap_features_hpa_for_part2(subfolder,cellnum,setno,fieldno,batchno,n_inputArray,mulen_inputArray,colli_inputArray,coeff_var_Array);

    if fin_mat(1)==-1  %%
       continue;
    end

    fin_mat_all = [fin_mat_all; [repmat([setno,fieldno,cellnum],[size(fin_mat,1),1]), fin_mat]];  %%

    if nargout <= 1
    if ~exist(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/'],'dir');
       mkdir(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/']);
    end
    save(['outputs_' num2str(subfolder) '/featvals/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/' imCategory '/' featType '/forpart2_all_feats_G_psf_batch_' num2str(batchno) '.mat'],'fin_mat');
    end
end

end % End of function

