clear all
close all

fieldnos = [1:30];

dataloc1 = [];  % image location, e.g. dataloc1 = ../images/HPA/images
dataloc2 = '../images/HPA/images';  % mask location for segmented cells

for setno = 1:3
	script_loadimage_script(setno,fieldnos,dataloc1,dataloc2);
end
