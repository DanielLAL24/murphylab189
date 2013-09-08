clear all
close all

cellnos = [1 2 6;
1 4 2;
1 8 2;
1 12 3];

setno = 1;
setno = 2;
setno = 3;
subfolder = 1;
batchno = 1;

dims = []; %setno 1, J 31; setno 2, J 2; setno 3, J 35
%for J = 1:size(cellnos,1)
%for J = 1:96
for J = 35
%for J = 3
%load(['outputs_1/results/set_' num2str(setno) '/result_new.mat'],'finTable');
load(['/home/ashariff/work52/outputs_1/results/set_' num2str(setno) '/result_new.mat'],'finTable');
%	fieldno = cellnos(J,2);
%	cellnum = cellnos(J,3);
%	I = intersect(find(finTable(:,7)==setno),intersect(find(finTable(:,8)==fieldno),find(finTable(:,9)==cellnum)));
       I = J; fieldno = finTable(J,8); cellnum = finTable(J,9);
	
	finTable(I,:)
	
	n = finTable(I,1);
	mu_len = finTable(I,2);
	sigma_len = finTable(I,3);
	colli_min_number = finTable(I,4);
	rad = 240;
	thr = finTable(I,5);
	[G_psf,G] = getsynimage_hpa(n,mu_len,sigma_len,colli_min_number,cellnum,batchno,setno,fieldno,subfolder,rad,thr);
	G_psf = G_psf(:,:,4); G = G(:,:,4);
       disp(size(G_psf)); dims(J,:) = size(G_psf);
	[protim3,Dbothfin,segdna,imgcent_coordinate] = getrealimage_hpa(setno,fieldno,cellnum);
%	imwrite(uint8([protim3, G_psf]),['fieldno_' num2str(fieldno) '.png'])
end

save script_figure2.mat


Dbothfin = Dbothfin(:,:,4);
segdna = segdna(:,:,4);
segcell = ~(Dbothfin - segdna);

G_psf = imresize(G_psf, 0.2/0.08);
G = imresize(G, 0.2/0.08);
segdna = imresize(segdna, 0.2/0.08);
segcell = imresize(segcell, 0.2/0.08);
Dbothfin = imresize(Dbothfin, 0.2/0.08);

G_psf = max(0,G_psf);
G = round(G); G = max(0,G);
segdna = double(segdna>0);
segcell = segcell>0;
Dbothfin = double(Dbothfin>0);

save('example_img.mat', 'G_psf', 'G', 'segdna', 'segcell', 'Dbothfin');
