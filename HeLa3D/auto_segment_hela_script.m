close all

for cellnum = [1 2 4 6 10 12:42 46:49 51:52]
	disp( ['Segmenting image: ' num2str(I) ] )
	auto_segment_hela(cellnum);
end
