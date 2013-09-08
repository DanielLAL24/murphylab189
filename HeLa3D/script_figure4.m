clear all
close all

n = 25; % n = 175;
mu_len = 25;
sigma_len = 1; % sigma_len = 25; 
colli_min_number = 0.95; % colli_min_number = 0.9;
cellnum = 1;
%n = 75;
%mu_len = 5;
%sigma_len = 25;
%colli_min_number = 0.95;
%cellnum = 2;

batchno = 1;
subfolder = 1;

[G_psf,imgcent_coordinate,imXYZ] = getsynimage_hela(n,mu_len,sigma_len,colli_min_number,cellnum,batchno,subfolder);

h=figure, hold on, for I = 1:size(imXYZ,2), plot3(imXYZ{I}(1,:),imXYZ{I}(2,:),imXYZ{I}(3,:),'k'), end
axis equal
set(gca,'XColor','w','YColor','w','ZColor','w')

saveas(h,'cell1_batch1_sim.fig');
%saveas(h,'cell2_batch1_sim.fig');

figure, imshow(uint8(sum(G_psf,3)))
