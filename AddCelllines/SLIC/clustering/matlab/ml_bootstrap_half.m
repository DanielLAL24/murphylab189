function ml_bootstrap_half(filename, treename, feat, name, cycle, meth, ...
    covs, lmeth, comment)
% FUNCTION ML_BOOTSTRAP_HALF(FILENAME, TREENAME, FEAT, NAME, CYCLE, METH, COVS, LMETH, COMMENT)
%   Create a bootstrap analysis using randomly halfing of the samples. Output 
%   to a file for consensus analysis program
% FILENAME: output file
% TREENAME: name of the tree
% FEAT: a cell with n (num of taxa) elements, each containing m features
% NAME: a cell array containing the names of the taxa
% CYCLE: number of cycles in bootstrap analysis, 100 by default
% METH: 0 for euclidean (default) and 1 for mahn
% COVS: if meth == 1 and invcov is a matrix, it will be used as the
%      covariance matrix, if it is empty, it will be calaulated from input.
% LMETH: method for linkage function, 'average' by defalt, 'single',
%        'complete','centroid' and 'ward' are other choices
%        'additive' for additive tree building
% COMMENT: comment to be written into the output file

% Copyright (C) 2006  Murphy Lab
% Carnegie Mellon University
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published
% by the Free Software Foundation; either version 2 of the License,
% or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
% 02110-1301, USA.
%
% For additional information visit http://murphylab.web.cmu.edu or
% send email to murphy@cmu.edu

% Xiang Chen, 12/22/2004

if (length(name)~=length(feat)) 
     error('lengths of names and features arrays must match.')
end

if (~exist('meth', 'var') | isempty(meth))
    meth = 0;
end

if (~exist('lmeth', 'var') | isempty(lmeth))
     lmeth = 'average';
end
if (~isnumeric(meth) | (meth ~= 0))
    meth = 1;
end

if (~exist('comment', 'var'))
     comment = [];
end

for m = 1 : length(feat)
     feat{m} = double(feat{m});
end

fid = fopen(filename, 'w'); %

if (~exist('cycle', 'var') | isempty(cycle)) 
     cycle = 100;
end

features=[];
allf = [];
for i=1:length(feat)
    features(i,:)=mean(feat{i}, 1);  %median or mean, default is mean
    allf = [allf
	     feat{i}];
end
zs=zscore(allf);
me = mean(allf);
sd = std(allf);
sd(find(sd==0)) = 1;
if meth==1     %zscore along column or no zscore, default is zscore along column
features = (features - repmat(me, [length(feat) 1])) ./ repmat(sd, [length(feat) 1]);
else           %use specifically 'measured' and 'selected' vector
features = [];
features = jl_measuredVector(feat, @median, 2, me, sd); %select one most representative cell for each protein
%features = (allf - repmat(me, [size(allf,1) 1])) ./ repmat(sd, [size(allf,1) 1]); %use all cells, zscore
%features = single(normr(features)); %%use all cells, normr
%features = single(features);
clear allf
%pack
end

if ((~exist('covs') | isempty(covs)) & meth)
    for i = 1 : length(feat)
        feat{i} = (feat{i} - repmat(me, [size(feat{i}, 1) 1])) ./ repmat(sd, [size(feat{i}, 1) 1]); %%zscore
    end
    covs = xc_cov(feat);
     %keyboard
end

save('features_norm.mat', 'features');

if ~strcmp(filename(end-2:end), 'MRC') %maybe for the usage of jl_drawtree
%Header of the output file
out = ['#NEXUS\n\n[\ntrees from\n\n' comment '\n]\n\n\n'];

%Taxa information
taxa = ['begin taxa;\ndimensions ntax = ' num2str(length(name)) ';\ntaxlabels'];
for m = 1 : length(name)
     %Remove '( , ) -' from the name
     %[s, t] = strtok(name{m}, '<');
     [s, t] = strtok(name{m}, '(');
     if (length(t))
	t(1) = []
     	%t = strtok(t, '>');
     	t = strtok(t, ')');
     	[t, t2] = strtok(t, ',');
     	while(~isempty(t2))
        	t2(1) = [];
		[t1, t2] = strtok(t2, ',');
        	t = [t '+' t1];
     	end	
     	%s = name{m}
     end;
     [s1, s2] = strtok(s, '-');
     if (isempty(s2))
         s = s1;
     else
         s2(1) = [];
         s = [s1 '_' s2];
     end
     name{m} = s;
     if (exist('t', 'var') & length(t))
        name{m} = [s '<' t '>'];
     end
     taxa = [taxa ' ' name{m}];
end
taxa = [taxa ';\nend;\n'];

%Original tree without bootstrap
if (meth == 0)
	dists = pdist(features,'euclid');
else
	dists = ml_pdist(features, 'mah', covs);
end

additive = strcmp(lmeth, 'additive');
if (additive)
     dists = squareform(dists);
     links = xc_neighborjoining(dists);
     out = [out taxa 'begin trees;\ntree fundamental_' treename ' = [&U][&W 1]'];
else
     links = linkage(dists, lmeth);
     out = [out taxa 'begin trees;\ntree fundamental_' treename ' = [&R][&W 1]'];
end

out = [out xc_link2tree(links, name) ';\nend;\n\n'];
flag_boot = 1
else
disp('Use Bootstrap to create den_MRC directly; and then use jl_drawtree!');  %%!!!!!!!!!!!!!!!!!!!!
%Header of the output file
out = ['#NEXUS\n\n']; %

%Taxa information
taxa = ['begin taxa;\ndimensions ntax = ' num2str(length(name)) ';\ntaxlabels'];
for m = 1 : length(name)
     %Remove '( , ) -' from the name
     %[s, t] = strtok(name{m}, '<');
     [s, t] = strtok(name{m}, '(');
     if (length(t))
	t(1) = []
     	%t = strtok(t, '>');
     	t = strtok(t, ')');
     	[t, t2] = strtok(t, ',');
     	while(~isempty(t2))
        	t2(1) = [];
		[t1, t2] = strtok(t2, ',');
        	t = [t '+' t1];
     	end	
     	%s = name{m}
     end;
     [s1, s2] = strtok(s, '-');
     if (isempty(s2))
         s = s1;
     else
         s2(1) = [];
         s = [s1 '_' s2];
     end
     name{m} = s;
     if (exist('t', 'var') & length(t))
        name{m} = [s '<' t '>'];
     end
     taxa = [taxa ' ' name{m}];
end
taxa = [taxa ';\nend;\n\n'];  %

%Original tree without bootstrap
if (meth == 0)
	dists = pdist(features,'euclid');
else
	dists = ml_pdist(features, 'mah', covs);
end
clear features
%keyboard
additive = strcmp(lmeth, 'additive');
if (additive)
     dists = squareform(dists);
     links = xc_neighborjoining(dists);
     out = [out taxa 'begin trees;\ntree *MAJORITY_RULE-COMPONENT = [&R]\n']; %
    
else
     links = linkage(dists, lmeth);
     out = [out taxa 'begin trees;\ntree *MAJORITY_RULE-COMPONENT = [&R]\n']; %
end
tree_nodes = xc_link2tree(links, name);
tree_nodes = regexprep(tree_nodes, ' ', '');
out = [out tree_nodes ';\nend;\n'];
flag_boot = 0
end

if flag_boot ==1
%Bootstrapping
out = [out taxa 'begin trees;\n'];

feat_boot = [];

if 1==2
%flag can be only 2 or 3, num_select should be >=4.
%only select 'num_select' vectors for each antibody (cell).
featcell = feat;
[measuredVector, feat] = jl_measuredVector(feat, @median, 3, me, sd, 4);
end

%rand('state',sum(100*clock))
%cycle = 0; %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
for m = 1 : cycle
     num_cycle = m
    [set1, set2] = xc_randomhalf(feat);
    features=[];
    allf = [];
    for i=1:length(feat)
        features(i,:)=mean(set1{i}, 1); %median or mean, default is mean
        allf = [allf
	        set1{i}];
    end
    me = mean(allf);
    sd = std(allf);
    sd(find(sd==0)) = 1;
    if 1==2     %zscore along column or no zscore, default is zscore along column
    features1 = (features - repmat(me, [length(feat) 1])) ./ repmat(sd, [length(feat) 1]);
    else
    features1 = features;
    end
    if 1==2       %zscore along row
    features1 = [];
    for i=1:length(set1)
        features1(i,:)=mean(zscore(set1{i},0,2), 1);  %median or mean, default is mean
    end
    end
    if 1==1      %zscore along column, then normalize along row
    features1 = [];
    for i=1:length(set1)
        features1(i,:)=mean(normr((set1{i} - repmat(me, [size(set1{i},1) 1])) ./ repmat(sd, [size(set1{i},1) 1])), 1);  %median or mean, default is mean
    end
    end
     if 1==2       %use specifically 'measured' and 'selected' vector
     features1 = [];
     features1 = jl_measuredVector(set1, @median, 3, me, sd);
     end

    features=[];
    allf = [];
    for i=1:length(feat)
        features(i,:)=mean(set2{i}, 1); %median or mean, default is mean
        allf = [allf
	        set2{i}];
    end
    me = mean(allf);
    sd = std(allf);
    sd(find(sd==0)) = 1;
    if 1==2     %zscore along column or no zscore, default is zscore along column
    features2 = (features - repmat(me, [length(feat) 1])) ./ repmat(sd, [length(feat) 1]);
    else
    features2 = features;
    end
    if 1==2     %zscore along row
    features2 = [];
    for i=1:length(set2)
        features2(i,:)=mean(zscore(set2{i},0,2), 1);  %median or mean, default is mean
    end
    end
    if 1==1     %zscore along column, then normalize along row
    features2 = [];
    for i=1:length(set2)
        features2(i,:)=mean(normr((set2{i} - repmat(me, [size(set2{i},1) 1])) ./ repmat(sd, [size(set2{i},1) 1])), 1);  %median or mean, default is mean
    end
    end
    if 1==2      %use specifically 'measured' and 'selected' vector
    features2 = [];
    features2 = jl_measuredVector(set2, @median, 3, me, sd);
    end

     feat_boot{m} = [features1; features2];

    if (meth == 0)
    	dists1 = pdist(features1, 'euclid');
    	dists2 = pdist(features2, 'euclid');
    elseif (meth == 2)
        dists1 = ml_pdist(features1, 'city');
        dists2 = ml_pdist(features2, 'city');
    elseif (meth == 3)
        dists1 = ml_pdist(features1, 'ca');
        dists2 = ml_pdist(features2, 'ca');
    else
	if (~exist('covs', 'var')) 
	    dists1 = pdist(features1, 'mah');
	    dists2 = pdist(features2, 'mah');
	else
	    dists1 = ml_pdist(features1, 'mah', covs);
	    dists2 = ml_pdist(features2, 'mah', covs);
	end    
    end
     length_dists1 = size(squareform(dists1))
     length_dists2 = size(squareform(dists2))
     %pause(2)
    if (additive)
        links1 = xc_neighborjoining(squareform(dists1));
         %disp('Bootstrapping');
         %pause;
        links2 = xc_neighborjoining(squareform(dists2));
        out = [out 'tree B_1.' num2str(2 * m - 1) ' = [&U][&W 1]'];
        out = [out xc_link2tree(links1, name) ';\n'];
        out = [out 'tree B_1.' num2str(2 * m) ' = [&U][&W 1]'];
        out = [out xc_link2tree(links2, name) ';\n'];
    else
        lmeth
	links1 = linkage(dists1, lmeth);
        links2 = linkage(dists2, lmeth);
        out = [out 'tree B_1.' num2str(2 * m - 1) ' = [&R][&W 1]'];
        out = [out xc_link2tree(links1, name) ';\n'];
        out = [out 'tree B_1.' num2str(2 * m) ' = [&R][&W 1]'];
        out = [out xc_link2tree(links2, name) ';\n'];
    end
    %keyboard
end
if exist('features1', 'var')
save('features_1-2_norm.mat', 'features1', 'features2');
end

save('feat_boot.mat', 'feat_boot', 'feat');

out = [out 'end;'];
end

fprintf(fid, out);
fclose(fid);

function cov_tmp = xc_cov(allf)
for m = 1 : length(allf)
    nocells(m) = size(allf{m}, 1);
end
s = min(nocells);
for m = 1 : 100
   tmpf = [];
   for n = 1 : length(allf) 
       x = randperm(size(allf{n}, 1));
       tmpf = [tmpf; allf{n}(x(1:s), :)];
   end
   cov_g(:,:,m) = cov(double(tmpf));
end
cov_tmp = mean(cov_g, 3);

function tree = xc_link2tree(links, names)
% FUNCTION TREE = XC_LINK2TREE(LINKS, NAMES)
% Convert a linkage matrix to a NEWICK format tree
% links: the linkage matrix from linkage function for dendrogram or from
%        xc_neighborjoining for additive tree
% names: a cell array containing the taxa name for each leave
% tree: NEWICK formatted output tree

taxadimension = size(links, 1) + 1;

if (~exist('names', 'var'))
     for m = 1 : taxadimension
         names{m} = num2str(m);
     end
end

if (length(names) < taxadimension)
     for m = length(names) + 1 : taxadimension
         names{m} = num2str(m);
     end
end

for m = 1 : taxadimension
     tmp{m} = names{m};
end

for m = 1 : (taxadimension - 1)
     tmp{taxadimension + m} = ['(' tmp{links(m, 1)} ', ' tmp{links(m, 2)} ')'];
end

tree = tmp{2 * taxadimension - 1};

function [set1, set2] = xc_randomhalf(feat)

% FUNCTION [SET1 SET2] = XC_RANDOMHALF(FEAT)
% Take in a cell array of features (each element of the cell array is a class)
% and randomly devide it into half (for each element) and return as set1 and
% set2

%rand('state',sum(100*clock));
for m = 1: length(feat)
     featsize = size(feat{m}, 1);
     r = randperm(featsize);
     set1{m} = feat{m}(r(1 : round(featsize / 2)) , :);
     set2{m} = feat{m}(r(round(featsize / 2) + 1 : featsize), :);
end

