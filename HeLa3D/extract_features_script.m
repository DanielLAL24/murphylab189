close all

batchno = 1;

for cellnum = [1 2 4 6 10 12:42 46:49 51:52]
	disp( ['Extracting features from image: ' num2str(cellnum) ] )
	all_script(cellnum,batchno);
end
