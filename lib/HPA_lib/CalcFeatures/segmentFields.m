function segmentFields(readdir,writedir)

% function segmentFields
% readdir is the directory storing all images;
% writedir is the directory for writing segmentation masks.

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


if ~exist('readdir','var')
    readdir = '/images/HPA/images/IFconfocal/';
end
if ~exist('writedir','var')
    writedir = './data/masks/';
end

IMAGEPIXELSIZE = 0.05; % um/px
MINNUCLEUSDIAMETER = 6; %um
MAXNUCLEUSDIAMETER = 14; %um

filetype = 'tif';

greparg = '| grep green';

ind = find(readdir=='/');
readdir_ = readdir;
readdir_(ind) = '_';

uout = unixfind( readdir, filetype, greparg);
readlist = listmatlabformat( uout);

uout_nuc = findreplacestring( uout, 'green','blue');
uout_tub = findreplacestring( uout, 'green','red');
uout_er = findreplacestring( uout, 'green','yellow');
readlist_nuc = listmatlabformat( uout_nuc);
readlist_tub = listmatlabformat( uout_tub);
readlist_er = listmatlabformat( uout_er);


mout = findreplacestring( uout, '/', '_');
mout = findreplacestring( mout, readdir_,writedir);
mout = findreplacestring( mout, '.tif','.png');

writelist = listmatlabformat( mout);

for i=1:length(readlist)
    i
    if exist(writelist{i},'file')
        continue;
    end

    tmpfile = writelist{i};
    tmpfile(find(tmpfile=='/')) = [];
    tmpfile(find(tmpfile=='.')) = [];
    tmpfile = ['./tmp/' tmpfile '.txt'];

    if exist(tmpfile,'file')
        continue;
    end
    fid = fopen(tmpfile,'w');

    nucim = imread(readlist_nuc{i});
    cellim = imread(readlist_er{i});

    regions = segmentation( nucim, cellim, MINNUCLEUSDIAMETER, MAXNUCLEUSDIAMETER, IMAGEPIXELSIZE);

    % saving results
    imwrite( regions, writelist{i});

    fclose(fid);
    delete(tmpfile);
end
