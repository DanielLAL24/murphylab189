% script of del_tcheckfiles
% delete tcheck files when necessary.

clear all
close all

addpath('/home/jieyuel/lib_backup/lib_Justin/HPAconfocal_lib/system')

%n_inputArray = [5,50:50:350,400];
n_inputArray = [5,50:50:350,400,450];  %% setno = 7

batchno = 1;

subfolder = 3;  %%Jieyue, Erlang, multi-steps rebound control

load HPAimagelist2.mat AddCellLines celllabels 

%for setno = unique(celllabels)'
for setno = 7

       fieldnos = 1:sum(celllabels==setno);
	for fieldno = fieldnos

		for thr = 6:8
			imagefolders = dir(['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_*']);
			for i = 1:length(imagefolders)
				imnum = str2num(imagefolders(i).name(7:end));
				disp([setno,fieldno,imnum,thr]);
				for n = n_inputArray
				try
				tcheckfiles = ls(['./outputs_' num2str(subfolder) '/images/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/thr_' num2str(thr) ...
						'/Image_' num2str(imnum) '/batch_' num2str(batchno) '/new_n_' num2str(n) '/' '*-tcheck.mat']);
				del_files = listmatlabformat(tcheckfiles);
				for j = 1:length(del_files)
					disp(del_files{j})
					delete(del_files{j});
				end
				catch
				disp('No such files');
				end
				end
			end
		end
	end
end
