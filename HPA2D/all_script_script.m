clear all
close all

% this script generates the simulated images and computes the features
% this script generates the simulated images jl AUG 31 2011

fieldnos{1} = 1:16;
fieldnos{2} = 1:30;
fieldnos{3} = 1:16;

%[1 8 2]
%for setno = 1:3
for setno = 2:3
	for fieldno = fieldnos{setno}
%	for fieldno = 8
		all_script(setno,fieldno);
		%all_script(setno,fieldno,imnum);
	end
end
