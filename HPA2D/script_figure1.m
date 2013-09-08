clear all
close all


setno = 1;
subfolder = 1;
batchno = 1;
cellnum = 6;
fieldno = 2;

load(['outputs_1/results/set_' num2str(setno) '/result_new.mat'],'finTable');

idx = intersect(find(finTable(:,7)==setno),intersect(find(finTable(:,8)==fieldno),find(finTable(:,9)==cellnum)));

I = idx;

n = finTable(I,1);
mu_len = finTable(I,2);
sigma_len = finTable(I,3);
colli_min_number = finTable(I,4);
rad = 240;
thr = finTable(I,5);
	
G_psf = getsynimage_hpa(n,mu_len,sigma_len,colli_min_number,cellnum,batchno,setno,fieldno,subfolder,rad,thr);
G_psf = G_psf(:,:,4);
[protim3,Dbothfin,segdna,imgcent_coordinate] = getrealimage_hpa(setno,fieldno,cellnum);

h = figure;
render_data(segdna2,'red',1)
hold on
render_data(segcell,'green',1)

alpha(0.3)
view(-1,30)
set(h,'color','white');

