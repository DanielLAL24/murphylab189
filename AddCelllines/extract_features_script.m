clear all
close all

% this script calculate features for the simulated images

load HPAimagelist2.mat AddCellLines celllabels 

for setno = unique(celllabels)'
%for setno = 11
%for setno = 7
	%imcount = 0;

	%for cellnum = 1:50  %%for selecting a subset
	%	if imcount>=10 break; end  %%for selecting a subset

       fieldnos = 1:sum(celllabels==setno);
	for fieldno = fieldnos
		extract_features(setno,fieldno);

		%[flag] = extract_features(setno,fieldno,cellnum);  %%for selecting a subset
		%imcount = imcount + flag;  %%for selecting a subset
		%if imcount>=10 break; end  %%for selecting a subset
	end

	%end  %%for selecting a subset

end
