function PIC_out = jl_PIC(feats, ks, truth, param)

if iscell(feats)
   data = feats{2};
   feats = feats{1};
end

if ~exist('ks','var')
   ks = 1:min(400,size(feats,1));
end

if ~exist('param','var')
   param.ks = ks;  %%
   param.tr = 1;  %%
   param.kmtrials = 100;
   %param.tr = 20;  %%
   %param.kmtrials = 10;
   param.dist = 'euc';  %%
   param.featdist = 'cosine';  %%
   %param.featdist = 'euclidean';  %%
   param.method = 0; %0 - choose by aic, 1 - choose by bic.
   param.alg = 'pic';
end

if ~exist('data','var')
data = squareform(pdist(feats, param.featdist));
end

aics = zeros(param.tr,length(ks));
bics = zeros(param.tr,length(ks));
alllabels = cell(param.tr,length(ks));
loglk = zeros(param.tr,length(ks));
for i = 1:length(ks)
    %i
    for j = 1:param.tr 
        %j

        [labels] = x_cluster_icml2010(data, ks(i), param.alg, param.kmtrials, truth);        

        unique_labels = unique(labels);
        tmp = zeros(length(labels),1);
        for uu = 1:length(unique_labels)
            tmp(ismember(labels, unique_labels(uu))) = uu;
        end
        labels = tmp;

        alllabels{j,i}.labels = labels;

        %[aics(j,i),bics(j,i)] = tz_aicbic2(feats, labels, param.dist);
        [aics(j,i),bics(j,i),loglk(j,i)] = tz_aicbic(feats, labels, param.dist);  %%
    end
end

PIC_out.aics = aics;
PIC_out.bics = bics;
PIC_out.loglk = loglk;
PIC_out.alllabels = alllabels;
clear alllabels

[ra,ca] = find(aics==min(aics(:)),1);
[rb,cb] = find(bics==min(bics(:)),1);
if param.method==0
   disp('Choose bestk by aic.')
   PIC_out.bestk = ks(ca);
   tmp = aics(:,ca);
   [tmp,idx] = min(tmp);
   PIC_out.labels = PIC_out.alllabels{idx,ca}.labels;
else
   disp('Choose bestk by bic.')
   PIC_out.bestk = ks(cb);
   tmp = bics(:,cb);
   [tmp,idx] = min(tmp);
   PIC_out.labels = PIC_out.alllabels{idx,cb}.labels;
end
clear aics bics alllabels tmp idx loglk

PIC_out.bestk 


