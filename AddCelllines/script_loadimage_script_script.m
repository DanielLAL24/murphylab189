clear all
close all

dataloc1 = [];  % image location, e.g. dataloc1 = ../images/HPA/images
dataloc2 = '../images/HPA/images';  % mask location for segmented cells

load HPAimagelist2.mat AddCellLines celllabels 

for setno = unique(celllabels)'
       fieldnos = 1:sum(celllabels==setno);
	script_loadimage_script(setno,fieldnos,dataloc1,dataloc2);
end
