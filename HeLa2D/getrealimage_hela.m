function [protim3,Dbothfin,segdna,imgcent_coordinate] = getrealimage_hela(imnum,thr)

%if ~exist('thr','var')
%   thr = 6;
%end
thr = 6;
load(['proc_' num2str(thr) '/cell_' num2str(imnum) '/final_info.mat'],'Dbothfin','imgcent_coordinate','segdna','protim3');
