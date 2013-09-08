function Hier_out = jl_HierClust(X, ks, dist, link, param)

addpath(genpath('./functions/tztoolbox'));  
addpath(genpath('./functions/SLIC'));  


if ~exist('dist','var')
   dist = 'euclidean';
end
if ~exist('link','var')
   link = 'average';
end

Y = pdist(X, dist);
Z = linkage(Y, link);

if ~exist('ks','var')
   ks = 1:(size(Z,1)+1);
end

if ~exist('param','var')
   param.ks = ks;  %%
   param.tr = 1;
   %param.dist = 'eu';
   param.dist = 'euc';  %%3kml
   if strcmp(dist,'mahalanobis') param.dist = 'mah';  end  %%3kml
   param.maxIter = 100;
   param.verbose = 0;
   param.method = 0; %0 - choose by aic, 1 - choose by bic.
end

aics = single(zeros(param.tr,length(ks)));
bics = single(zeros(param.tr,length(ks)));
alllabels = cell(param.tr,length(ks));
loglk = single(zeros(param.tr,length(ks)));
for i = 1:length(ks)
    i
    for j = 1:param.tr
        labels = cluster(Z,'maxclust',ks(i));
        alllabels{j,i}.labels = labels;
        %[aics(j,i),bics(j,i),loglk(j,i)] = tz_aicbic2(X, labels, param.dist);
        switch param.dist
               case 'euc'
                    [aics(j,i),bics(j,i),loglk(j,i)] = tz_aicbic(X, labels, param.dist);  %%3kml, euc
               case 'mah'
                    [aics(j,i),bics(j,i)] = tz_aicbic(X, labels, param.dist);  %%3kml, mah
               otherwise
                    error('Unrecognizable param.dist!');
        end
    end
end
Hier_out.aics = aics;
Hier_out.bics = bics;
Hier_out.loglk = loglk;
Hier_out.alllabels = alllabels;
clear alllabels

[ra,ca] = find(aics==min(aics(:)),1);
[rb,cb] = find(bics==min(bics(:)),1);
if param.method==0
   disp('Choose bestk by aic.')
   Hier_out.bestk = ks(ca);
   tmp = aics(:,ca);
   [tmp,idx] = min(tmp);
   Hier_out.labels = Hier_out.alllabels{idx,ca}.labels;
else
   disp('Choose bestk by bic.')
   Hier_out.bestk = ks(cb);
   tmp = bics(:,cb);
   [tmp,idx] = min(tmp);
   Hier_out.labels = Hier_out.alllabels{idx,cb}.labels;
end
clear aics bics alllabels tmp idx loglk

Hier_out.bestk 

