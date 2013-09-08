close all

for cellnum = [1 2 4 6 10 12:42 46:49 51:52]
	disp( ['Processing segmented image: ' num2str(I) ] )
	process_seg_hela(cellnum);
end
