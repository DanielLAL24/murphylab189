function [out,outidx] = jl_mode(labels, feats)

[a, b] = hist(labels, unique(labels));

[c, idx] = sort(a, 'descend');
ind = find(a==c(1));

if length(ind)==1
   out = b(ind);
   if nargout>=2
      dists = squareform(pdist(zscore(feats)));
      tmpdists = mean(dists,2);
      [~,idx] = min(tmpdists(labels==out));
      outidx = idx;
   end
else
   if ~exist('dists','var')
      dists = squareform(pdist(zscore(feats)));
      tmpdists = mean(dists,2);
   end
   gmean = zeros(length(ind),1);
   for i = 1:length(ind)
       idx = labels==b(ind(i));
       gmean(i) = mean(tmpdists(idx));
   end
   [~,idx] = min(gmean);
   out = b(ind(idx));
   [~,idx] = min(tmpdists(labels==out));
   outidx = idx;
end
