function [imgcent_coordinate] = sample_cent(Dbothfin, segdna, segcell, rand_seed)

% Dbothfin: cytosolic space, 0 - inside, 1 - outside;
% segdna: segmented nucleus, 0 - outside, 1 - inside;
% segcell: segmented cell,  0 - outside, 1 - inside.
% rand_seed: rand seed for generation.

rand('seed',rand_seed); randn('seed',rand_seed);

load cent_dist p slice

R = gamrnd(p(1),p(2));

segdna = segdna(:,:,slice);
segcell = segcell(:,:,slice);
Dbothfin = Dbothfin(:,:,slice);

[D1] = bwdist(segdna>0);
[D2] = bwdist((~segcell)>0);

Dbothfin = double(~Dbothfin);
Dbothfin(Dbothfin==0) = NaN;
D1 = D1.*double(Dbothfin); 
D2 = D2.*double(Dbothfin);

DD = D1./D2;
DD = DD - R;
%DD = abs(DD(:,:,slice));
DD = abs(DD);

[a,b] = find(DD==min(min(DD)));
aaa = randperm(length(a));

imgcent_coordinate = [a(aaa(1)),b(aaa(1)),slice];
