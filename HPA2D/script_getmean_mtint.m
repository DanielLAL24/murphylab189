clear all
close all

dataloc1 = [];  % image location, e.g. dataloc1 = ../images/HPA/images
dataloc2 = '../images/HPA/images';  % mask location for segmented cells

for setno = 1:3
	for fieldno = 1:50
		mint{setno,fieldno} = script_estimate_mtint(setno,fieldno,dataloc1,dataloc2);
	end
end

save mtints

