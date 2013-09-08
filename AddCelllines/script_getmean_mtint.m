clear all
close all

dataloc1 = [];  % image location, e.g. dataloc1 = ../images/HPA/images
dataloc2 = '../images/HPA/images';  % mask location for segmented cells

load HPAimagelist2.mat AddCellLines celllabels 

for setno = unique(celllabels)'
       for fieldno = 1:sum(celllabels==setno)
		disp([setno, fieldno])
		mint{setno,fieldno} = script_estimate_mtint(setno,fieldno,dataloc1,dataloc2);
	end
end

save mtints

