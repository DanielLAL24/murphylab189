% script of del_tcheckfiles
% delete tcheck files when necessary.

clear all
close all

fieldnos{1} = 1:16;
fieldnos{2} = 1:30;
fieldnos{3} = 1:16;

batchno = 1;

%subfolder = 1;  %%Aabid, Gaussian: /home/ashariff/work52/outputs_1/images/
%subfolder = 2;  %%Jieyue, Erlang, one-step rebound control
subfolder = 3;  %%Jieyue, Erlang, multi-steps rebound control

for setno = 1:3
	for fieldno = fieldnos{setno}
		for thr = 6:8
			imagefolders = dir(['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_*']);
			for i = 1:length(imagefolders)
				imnum = str2num(imagefolders(i).name(7:end));
				tcheckfiles = ls(['./outputs_' num2str(subfolder) '/images/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/thr_' num2str(thr) ...
						'/Image_' num2str(imnum) '/batch_' num2str(batchno) '/new_n_*/' '*-tcheck.mat']);
				del_files = listmatlabformat(tcheckfiles);
				for j = 1:length(del_files)
					disp(del_files{j})
					delete(del_files{j});
				end
			end
		end
	end
end
