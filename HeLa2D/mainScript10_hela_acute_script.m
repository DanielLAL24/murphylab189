function mainScript10_hela_acute_script(cellnum,batchno)

%subfolder = 1;  % Aabid's Gaussian model
%subfolder = 2;  %%Jieyue, Erlang, one-step rebound control
subfolder = 3;  %%Jieyue, Erlang, multi-steps rebound control

%n_inputArray = [5,50:50:350];
n_inputArray = [5, 25, 50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300, 350];
randstarts = 1:1000:100000;
rand_starts = ((batchno-1)*100000)+randstarts;

for thr = 6:8
	for I = 1:size(n_inputArray,2)
		mainScript10_hela_acute( n_inputArray(I), rand_starts(I), batchno, ... 
			cellnum, subfolder, thr );
	end
end
