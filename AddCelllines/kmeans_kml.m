function kmeans_out = kmeans_kml(feats, ks, param)

addpath '/home/jieyuel/lib_backup/kml'
addpath(genpath('/home/jieyuel/lib_backup/gnf_unmix_code/PatternUnmixing/functions/tztoolbox'));  
addpath(genpath('/home/jieyuel/lib_backup/gnf_unmix_code/PatternUnmixing/functions/SLIC'));  

if ~exist('ks','var')
   ks = 1:min(400,size(feats,1));
end

if ~exist('param','var')
   param.type = 3; %0 - Lloyds, 1 - Swap, 2 - EZ_Hybrid, 3 - Hybrid (recommended).
   param.ks = ks;  %%
   param.tr = 20;  %%
   %param.dist = 'eu';
   param.dist = 'euc';  %%3kml
   param.maxIter = 100;
   param.verbose = 0;
   param.method = 0; %0 - choose by aic, 1 - choose by bic.
end

aics = single(zeros(param.tr,length(ks)));
bics = single(zeros(param.tr,length(ks)));
alllabels = cell(param.tr,length(ks));
loglk = single(zeros(param.tr,length(ks)));
for i = 1:length(ks)
    %i
    for j = 1:param.tr 
        %j
        disp([i,j]);
        %if ~exist(writefile,'file')
        [centers distortion] = kml(single(feats'), ks(i), param.type, param.maxIter, param.verbose);
        centers = centers';
        alllabels{j,i}.centers = centers;
        labels = int16(zeros(size(feats,1),1));

        [ndata, dimx] = size(feats);
        [ncentres, dimc] = size(centers);
        if dimx ~= dimc
            error('Data dimension does not match dimension of centres')
        end
        try
           n2 = ((ones(ncentres, 1)) * (sum((feats.^2)', 1)))' + ...
                (ones(ndata, 1)) * (sum((centers.^2)',1)) - ...
                2.*((feats)*((centers)'));
           [tmp,labels] = min(n2,[],2);
           clear n2 tmp
        catch
           warning('May be out of memory. Use loops.');
           for t = 1:ndata
               tmpdata = repmat(feats(t,:),[ncentres,1]);
               tmp = sum((tmpdata-centers).^2,2);
               [tmp,idx] = min(tmp);
               labels(t,1) = idx;
               clear tmpdata tmp idx
           end
        end
        alllabels{j,i}.labels = labels;
        %keyboard
        %{
        else
        warning([writefile,' existed!']);
        load(writefile,'kmeans_out')
        labels = kmeans_out.alllabels{j,i}.labels;
        alllabels{j,i} = kmeans_out.alllabels{j,i};
        end
        %}

	 %try
        %[aics(j,i),bics(j,i)] = tz_aicbic2(feats, labels, param.dist);
	 %if isinf(aics(j,i)) aics(j,i) = 1/eps; end  %%
	 %if isinf(bics(j,i)) bics(j,i) = 1/eps; end  %%
	 %catch
	 %aics(j,i) = 1/eps; bics(j,i) = 1/eps;  %%
	 %end
        %keyboard
        [aics(j,i),bics(j,i),loglk(j,i)] = tz_aicbic(feats, labels, param.dist);  %%3kml
        clear centers labels
    end
end
kmeans_out.aics = aics;
kmeans_out.bics = bics;
kmeans_out.loglk = loglk;
kmeans_out.alllabels = alllabels;
clear alllabels

[ra,ca] = find(aics==min(aics(:)),1);
[rb,cb] = find(bics==min(bics(:)),1);
if param.method==0
   disp('Choose bestk by aic.')
   kmeans_out.bestk = ks(ca);
   tmp = aics(:,ca);
   [tmp,idx] = min(tmp);
   kmeans_out.labels = kmeans_out.alllabels{idx,ca}.labels;
   kmeans_out.centroids = kmeans_out.alllabels{idx,ca}.centers;
else
   disp('Choose bestk by bic.')
   kmeans_out.bestk = ks(cb);
   tmp = bics(:,cb);
   [tmp,idx] = min(tmp);
   kmeans_out.labels = kmeans_out.alllabels{idx,cb}.labels;
   kmeans_out.centroids = kmeans_out.alllabels{idx,cb}.centers;
end
clear aics bics alllabels tmp idx loglk

kmeans_out.bestk 

