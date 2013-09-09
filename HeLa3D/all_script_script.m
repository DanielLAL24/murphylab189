clear all
close all

batchno = 1;

disp(['Batch number:' num2str(batchno)])
for cellnum = [1 2 4 6 10 12:42 46:49 51:52]
	disp( ['Image: ' num2str(cellnum) ] )
	tic;
	mainScript10_hela_acute_script( cellnum, batchno );
    %all_script(cellnum,batchno);

    end_time = toc;
    fprintf('%d minutes and %f seconds\n',floor(end_time/60),rem(end_time,60));
end
