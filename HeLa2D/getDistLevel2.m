function [levels] = getDistLevel2(image,imnum,thr,numLevels)


[protim3,Dbothfin,segdna] = getrealimage_hela(imnum,thr);
image = double(~Dbothfin(:,:,4)).*image;  %%%%

segcell = Dbothfin + segdna;
segcell(segcell==2) = 0;
[D,L] = bwdist(segcell(:,:,4)>0);  %%
D = D.*double(~segdna(:,:,4));  %%
unique_D = unique(D);
unique_D(1) = [];

if ~exist('numlevels','var')
   numlevels = 10;  %% Please also check hist_DistLevel_Curvelet_DistLevel.m for the compatibility.
   numlevels = min(numlevels,length(unique_D));
   %numlevels = max(numlevels,ceil(sqrt(length(unique_D))));
end
interval = floor(length(unique_D)/numlevels);

levels = cell(numlevels,1);

for i = 1:numlevels-1
    [idxr,idxc,idxz] = ind2sub(size(D),find(D>unique_D(1+interval*(i-1))-1e-6 & D<unique_D(interval*i+1)-1e-6));
    idx = find(D>unique_D(1+interval*(i-1))-1e-6 & D<unique_D(interval*i+1)-1e-6);
    ind = find(image(idx)); idxr = idxr(ind); idxc = idxc(ind); idxz = idxz(ind); idx = idx(ind);  %%The difference between getDistLevel2 and getDistLevel.
    levels{i} = [idxr(:),idxc(:),idxz(:),image(idx)];
    if isempty(levels{i})  %%
       warning('Empty level!');
       levels{i} = [0,0,0,0];
    end
end
    i = numlevels;
    [idxr,idxc,idxz] = ind2sub(size(D),find(D>unique_D(1+interval*(i-1))-1e-6 & D<unique_D(end)+1e-6));
    idx = find(D>unique_D(1+interval*(i-1))-1e-6 & D<unique_D(end)+1e-6);
    ind = find(image(idx)); idxr = idxr(ind); idxc = idxc(ind); idxz = idxz(ind); idx = idx(ind);  %%The difference between getDistLevel2 and getDistLevel.
    levels{i} = [idxr(:),idxc(:),idxz(:),image(idx)];
    if isempty(levels{i})  %%
       warning('Empty level!');
       levels{i} = [0,0,0,0];
    end
