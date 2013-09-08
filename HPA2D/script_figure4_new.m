clear all
close all

%subfolder = 2;
subfolder = 3;
batchno = 1;

dims = []; 
fieldnos = [2,6,6];
cellnums = [6,4,3]; 
%Is = [31,2,35];
for J = 1:3
	setno = J;
	fieldno = fieldnos(J);
	cellnum = cellnums(J);

	load(['outputs_' num2str(subfolder) '/results/set_' num2str(setno) '/result_new_0_0_0_0_1_1_1_1_1_0_0_0_0.mat'],'finTable');
	%load(['/home/ashariff/work52/outputs_1/results/set_' num2str(setno) '/result_new.mat'],'finTable');

	%[~,I] = min(sum(abs(finTable(:,1:2) - repmat(mean(finTable(:,1:2), 1),[size(finTable,1),1]))./repmat(mean(finTable(:,1:2), 1),[size(finTable,1),1]),2));
	I = intersect(find(finTable(:,7)==setno),intersect(find(finTable(:,8)==fieldno),find(finTable(:,9)==cellnum)));
	%I = Is(J);
	%[~,I] = min(finTable(:,6));

       fieldno = finTable(I,8); cellnum = finTable(I,9);
	
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
	imwrite(uint8([protim3, G_psf]),['setno_' num2str(setno) '.tif'],'Resolution',150);
end

