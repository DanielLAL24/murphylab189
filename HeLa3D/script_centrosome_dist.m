close all
clear all

% centrosome location distribution

load centrosome
slice = mode(imcents(3,:),2) - 20;

cent_dist = [];
for cellnum = [1 2 4 6 10 12:42 46:49 51:52]
    [~,~,segdna,segcell,~,~,imgcent_coordinate] = getrealimage_hela(cellnum);

    [D1] = bwdist(segdna>0);
    [D2] = bwdist((~segcell)>0);
    cent_dist = [cent_dist;[D1(imgcent_coordinate(1),imgcent_coordinate(2),imgcent_coordinate(3)-20),D2(imgcent_coordinate(1),imgcent_coordinate(2),imgcent_coordinate(3)-20)]];
end

clear segdna segcell cellnum imgcent_coordinate D1 D2

save cent_dist

% gamma fit

[p] = gamfit(double(cent_dist(:,1)./cent_dist(:,2)));


save cent_dist

