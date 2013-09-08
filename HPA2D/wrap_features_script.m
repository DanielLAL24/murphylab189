clear all
close all

% this script wrap the calculated features for the simulated images

fieldnos{1} = 1:16;
fieldnos{2} = 1:30;
fieldnos{3} = 1:16;

for setno = 3
	for fieldno = fieldnos{setno}
		wrap_features(setno,fieldno);
	end
end

