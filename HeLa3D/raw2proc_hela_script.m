clear all
close all

% some cells in here were left out because they have imaging errors

%icaoberg 9/8/2013
%not needed it. we inherited from master script
%imgloc = [];  % location of HeLa 3D images, e.g. imgloc = '../images/Hela';

for I = [1:4 6:42 44:52]
	disp( ['Preprocessing image: ' num2str(i) ] )
	raw2proc_hela(I, imgloc);
end
