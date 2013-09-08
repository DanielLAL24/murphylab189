function [l_img] = getDistLevel2_gus(image,setno,fieldno,cellnum,numlevels)


[protim3,Dbothfin,segdna] = getrealimage_hpa(setno,fieldno,cellnum);
image = double(~Dbothfin(:,:,4)).*image;  %%%%

segcell = Dbothfin + segdna;
segcell(segcell==2) = 0;
[D,L] = bwdist(segcell(:,:,4)>0);  %%

l_img = segcell*0;

ww = find(segdna>0);
D(ww) = -1;
m_level = linspace(1,max(D(:)),numlevels+1);

for i=1:numlevels
   
    ww = find( D >= m_level(i) & D<m_level(i+1) );
    l_img(ww) = i;
end


