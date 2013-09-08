close all
clear all

% centrosome location distribution

slice = 4;

cent_dist = [];
for setno = 1:3
    for fieldno = 1:30
        for imnum = 1:50
            if exist(['./proc_6/set_',num2str(setno),'/fieldno_',num2str(fieldno),'/Image_',num2str(imnum),'/'],'dir')
               [~,Dbothfin,segdna,imgcent_coordinate] = getrealimage_hpa(setno,fieldno,imnum);

               segcell = ~Dbothfin + segdna;
               [D1] = bwdist(segdna>0);
               [D2] = bwdist((~segcell)>0);
               cent_dist = [cent_dist;[D1(imgcent_coordinate(1),imgcent_coordinate(2),imgcent_coordinate(3)),...
                           D2(imgcent_coordinate(1),imgcent_coordinate(2),imgcent_coordinate(3))]];
            end
        end
    end
end

clear segdna segcell cellnum imgcent_coordinate D1 D2 Dbothfin

save cent_dist

% gamma fit

[p] = gamfit(double(cent_dist(:,1)./cent_dist(:,2)));


save cent_dist

