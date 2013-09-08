close all
clear all

load HPAimagesList

anti1 = antibodyids((cellabels==1)&(classlabels==26)); % class 26, loc_Cytoskeleton_microtubules
anti2 = antibodyids((cellabels==2)&(classlabels==26));
anti3 = antibodyids((cellabels==3)&(classlabels==26));

anti = intersect(anti1,intersect(anti2,anti3));

ind = ismember(antibodyids,anti);
antibodyids = antibodyids(ind);
cellabels = cellabels(ind);
classlabels = classlabels(ind);
imagelist = imagelist(ind);

save HPAimagesList2.mat

% maybe good proteins (HPA antibodies): [649 2823 5789 6376 7210 15068]
% maybe better ones: 2823

