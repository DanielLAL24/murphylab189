clear all
close all

% this script generates the simulated images and computes the features
% this script generates the simulated images jl AUG 31 2011

load HPAimagelist2.mat AddCellLines celllabels 

for setno = unique(celllabels)'
%for setno = 11
	%imcount = 0;

	%for cellnum = 1:50  %%for selecting a subset
		%if imcount>=10 break; end  %%for selecting a subset

       fieldnos = 1:sum(celllabels==setno);
	for fieldno = fieldnos
		all_script(setno,fieldno);

		%[flag] = all_script(setno,fieldno,cellnum);  %%for selecting a subset
		%imcount = imcount + flag;  %%for selecting a subset
		%if imcount>=10 break; end  %%for selecting a subset
	end

	%end  %%for selecting a subset

end
