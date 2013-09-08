clear all
close all

batchno = 1;

Heights = [];
for cellnum = [1 2 4 6 10 12:42 46:49 51:52]
    load(['/home/jieyuel/lib_backup/Microtubules/proc/cell_' num2str(cellnum) '/final_info.mat'],'Dbothfin');
    tmp = squeeze(sum(sum(~Dbothfin,1),2));
    Heights = [Heights; sum(tmp>0)];
end

save cell_height.mat

