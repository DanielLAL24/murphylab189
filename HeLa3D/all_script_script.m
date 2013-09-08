clear all
close all

batchno = 1;

for cellnum = [1 2 4 6 10 12:42 46:49 51:52]
	disp(['(Batch number, cell number):(' num2str(batchno) ',' num2str(cellnum) ')'])
	mainScript10_hela_acute_script( cellnum, batchno );
    %all_script(cellnum,batchno);
end
