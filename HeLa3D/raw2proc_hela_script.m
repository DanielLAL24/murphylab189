close all

% some cells in here were left out because they have imaging errors

for I = [1:4 6:42 44:52]
	disp( ['Preprocessing image: ' num2str(I) ] )
	raw2proc_hela( I, imgpath );
end
