function calcRegionFeat(rootdir)

% rootdir is the root directory storing all images.

% Copyright (C) 2010  Murphy Lab
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

% 10 Jan 10 - Jieyue Li


fsetnames = {...
    'overlap', ...
    'overlapx2', ...
    'nonObjFluor', ...
    'nonObjFluorx2', ...
    'obj', ...
    'objx2', ...
    'mutualInfo', ...
    'mutualInfox2', ...
    'texture', ...
    'texturex2', ...
    'texturex4', ...
    'tas', ...
    'tasx2', ...
    'objRegion',...
    'objRegionx2',...
};


datasettype = 'Region';
% fsetnames = {'nuclearRegion'};
if ~exist(['./data/features/' lower(datasettype) '/'],'dir')
   mkdir(['./data/features/' lower(datasettype) '/']);
end


if ~exist('rootdir','var')
    rootdir = '/images/HPA/images/IFconfocal/';
end
filetype = 'tif';
greparg = ' | grep green';

ind = find(rootdir=='/');
rootdir_ = rootdir;
rootdir_(ind) = '_';

uout = unixfind( rootdir, filetype, greparg);
readlist = listmatlabformat( uout);

uout_nuc = findreplacestring( uout, 'green','blue');
uout_tub = findreplacestring( uout, 'green','red');
uout_er = findreplacestring( uout, 'green','yellow');
readlist_nuc = listmatlabformat( uout_nuc);
readlist_tub = listmatlabformat( uout_tub);
readlist_er = listmatlabformat( uout_er);


mout = findreplacestring( uout, '/', '_');
mout = findreplacestring( mout, '.tif', '.png');
mout = findreplacestring( mout, rootdir_, ['./data/masks/']);
readlist_mask = listmatlabformat( mout);


cleanobject.channel_path = [];
cleanobject.channel = [];
cleanobject.channel_mcp = [];
cleanobject.channel_filtered = [];
cleanobject.channel_thr = [];
cleanobject.channel_mthr = [];
cleanobject.channel_fg = [];
cleanobject.channel_regions = [];
cleanobject.channel_objectsizes = [];
cleanobject.downsampled2x = [];
cleanobject.downsampled2x_filtered = [];
cleanobject.downsampled2x_thr = [];
cleanobject.downsampled2x_mthr = [];
cleanobject.downsampled2x_fg = [];
cleanobject.downsampled2x_objectsizes = [];
cleanobject.downsampled4x = [];
DSF = 2;
for i=1:length(readlist)
    i
    tmpfile = [readlist{i} '_' datasettype];
    tmpfile(find(tmpfile=='/')) = [];
    tmpfile(find(tmpfile=='.')) = [];
    tmpfile = ['./tmp/' tmpfile '_REGION.txt'];

    if exist(tmpfile,'file')
        continue;
    end
    fid = fopen(tmpfile,'w');

    protfieldstruct = cleanobject;
    nucfieldstruct = cleanobject;
    tubfieldstruct = cleanobject;
    erfieldstruct = cleanobject;
    maskfieldstruct = cleanobject;

    for zed = 1:length(fsetnames)
        mout = findreplacestring( readlist{i}, '/', '_');
        mout = findreplacestring( mout, '.tif', ['_' fsetnames{zed} '.mat']);
        writepath = findreplacestring( mout, rootdir_, ['./data/features/' lower(datasettype) '/']); %%
        
        if exist(writepath,'file')
            continue;
        end
        
        tmpfile2 = writepath;
        tmpfile2(find(tmpfile2=='/')) = [];
        tmpfile2(find(tmpfile2=='.')) = [];
        tmpfile2 = ['./tmp/' tmpfile2 '_REGION.txt']; %%

        if exist(tmpfile2,'file')
            continue;
        end
        fid2 = fopen(tmpfile2,'w');

        protfieldstruct.channel_path = readlist{i};
        nucfieldstruct.channel_path = readlist_nuc{i};
        tubfieldstruct.channel_path = readlist_tub{i};
        erfieldstruct.channel_path = readlist_er{i};
        maskfieldstruct.channel_path = readlist_mask{i};

        maskAllChannels
        
        allfeats = [];
        for j=1:length(protfieldstruct.channel_regions)
            protstruct = cleanobject;
            nucstruct = cleanobject;
            tubstruct = cleanobject;
            erstruct = cleanobject;

            protstruct.channel_path = readlist{i};
            nucstruct.channel_path = readlist_nuc{i};
            tubstruct.channel_path = readlist_tub{i};
            erstruct.channel_path = readlist_er{i};
            maskstruct.channel_path = readlist_mask{i};

            protstruct.channel = protfieldstruct.channel_regions{j};
            nucstruct.channel = nucfieldstruct.channel_regions{j};
            tubstruct.channel = tubfieldstruct.channel_regions{j};
            erstruct.channel = erfieldstruct.channel_regions{j};

            commonScriptCalculateSet

            allfeats = [allfeats; feats];
        end

        feats = allfeats;
        impath = readlist{i};

        % saving results
        save( writepath,'feats','names','slfnames','impath');

        fclose(fid2);
        delete(tmpfile2);
    end
    fclose(fid);
    delete(tmpfile);
end
