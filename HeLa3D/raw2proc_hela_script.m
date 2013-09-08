clear all
close all

% some cells in here were left out because they have imaging errors

imgloc = [];  % location of HeLa 3D images, e.g. imgloc = '../images/Hela';

for I = [1:4 6:42 44:52]
	raw2proc_hela(I, imgloc);
end
