function [protim3,Dbothfin,segdna,imgcent_coordinate] = getrealimage_hpa(setno,fieldno,imnum)

load(['proc_6/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(imnum) '/final_info.mat'],'protim3','Dbothfin','segdna','imgcent_coordinate');
