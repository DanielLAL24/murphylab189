clear all
close all

% this script calculate features for the simulated images

fieldnos{1} = 1:16;
fieldnos{2} = 1:30;
fieldnos{3} = 1:16;

batchnos = 2:6; 

for batchno = batchnos
%[1 8 2]
%for setno = 1:3
for setno = 3
%	for fieldno = fieldnos{setno}
	for fieldno = 7
              %extract_features(setno,fieldno);
              imnum = 1;
		extract_features(setno,fieldno,imnum,batchno);
	end
end
end

