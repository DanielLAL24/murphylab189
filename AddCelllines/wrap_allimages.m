close all
clear all

familyfolder = '/home/jieyuel/lib_backup/data/AdditionalCelllineImages/AdditionalCelllineImages';
%familyfolder = '../images/HPA/images/AdditionalCelllineImages';  % change to the default data (images) folder

AddCellLines = [{'RT4'},{'PC3'},{'HepG2'},{'HeLa'},{'CaCo'},{'A549'},{'Hek293'},{'MCF7'}];

celllabels = [];
nucimagelist = [];
mtimagelist = [];
erimagelist = [];
protimagelist = [];
writelist = [];

%addpath(genpath('/home/jieyuel/lib_backup/HPA_lib/HPA_lib/segmentation'));
IMAGEPIXELSIZE = 0.08013; % um/px
MINNUCLEUSDIAMETER = 8; %um
MAXNUCLEUSDIAMETER = 26; %um

for i = [1,3,5,6,7,8]
    files = dir([familyfolder,'/',AddCellLines{i},'/','*_z0_ch00.tif']);
    if i==5  files(end-1:end) = [];  end  %%
    for j = 1:length(files)
        disp([i,j]);
        nucimagelist = [nucimagelist; {[familyfolder,'/',AddCellLines{i},'/',files(j).name]}];
        mtimagelist = [mtimagelist; {[familyfolder,'/',AddCellLines{i},'/',files(j).name(1:end-5),'1.tif']}];
        if exist([familyfolder,'/',AddCellLines{i},'/',files(j).name(1:end-5),'2.tif'], 'file')
        erimagelist = [erimagelist; {[familyfolder,'/',AddCellLines{i},'/',files(j).name(1:end-5),'2.tif']}];
        else
        erimagelist = [erimagelist; {''}];
        end
        protimagelist = [protimagelist; {''}];
        celllabels = [celllabels; i+3];

        % seeded watershed segmentation
        nucim = double(imread(nucimagelist{end}));
        if ~isempty(erimagelist{end})
        cellim = double(imread(erimagelist{end})); cellim = cellim(:,:,1);
        else
        cellim = double(imread(mtimagelist{end}));
        end

        nucim = sum(nucim,3); cellim = sum(cellim,3);
        %nucim = nucim/max(max(nucim)) * 255;  %% 16bit image
        %cellim = cellim/max(max(cellim)) * 255;  %% 16bit image
        if max(max(nucim)) > 255  nucim = nucim/(2^16-1)*255;  end  %% 16bit image
        if max(max(cellim)) > 255  cellim = cellim/(2^16-1)*255;  end  %% 16bit image

        regions = segmentation( nucim, cellim, MINNUCLEUSDIAMETER, MAXNUCLEUSDIAMETER, IMAGEPIXELSIZE);

        writelist = [writelist; {[familyfolder,'/',AddCellLines{i},'/',files(j).name(1:end-3),'png']}];
        imwrite( regions, writelist{end});
    end
end

for i = [2,4,5]
    files = dir([familyfolder,'/',AddCellLines{i},'/','*',AddCellLines{i},'*_z0_ch01.tif']);
    if i==5  files(1:4) = [];  end  %%
    for j = 1:length(files)
        disp([i,j]);
        nucimagelist = [nucimagelist; {[familyfolder,'/',AddCellLines{i},'/',files(j).name]}];
        mtimagelist = [mtimagelist; {[familyfolder,'/',AddCellLines{i},'/',files(j).name(1:end-5),'3.tif']}];
        if exist([familyfolder,'/',AddCellLines{i},'/',files(j).name(1:end-5),'2.tif'], 'file')
        erimagelist = [erimagelist; {[familyfolder,'/',AddCellLines{i},'/',files(j).name(1:end-5),'2.tif']}];
        else
        erimagelist = [erimagelist; {''}];
        end
        protimagelist = [protimagelist; {[familyfolder,'/',AddCellLines{i},'/',files(j).name(1:end-5),'0.tif']}];
        celllabels = [celllabels; i+3];

        % seeded watershed segmentation
        nucim = double(imread(nucimagelist{end}));
        if ~isempty(erimagelist{end})
        cellim = double(imread(erimagelist{end})); cellim = cellim(:,:,1);
        else
        cellim = double(imread(mtimagelist{end}));
        end

        nucim = sum(nucim,3); cellim = sum(cellim,3);
        %nucim = nucim/max(max(nucim)) * 255;  %% 16bit image
        %cellim = cellim/max(max(cellim)) * 255;  %% 16bit image
        if max(max(nucim)) > 255  nucim = nucim/(2^16-1)*255;  end  %% 16bit image
        if max(max(cellim)) > 255  cellim = cellim/(2^16-1)*255;  end  %% 16bit image

        regions = segmentation( nucim, cellim, MINNUCLEUSDIAMETER, MAXNUCLEUSDIAMETER, IMAGEPIXELSIZE);

        writelist = [writelist; {[familyfolder,'/',AddCellLines{i},'/',files(j).name(1:end-3),'png']}];
        imwrite( regions, writelist{end});
    end
end

save HPAimagelist2.mat familyfolder AddCellLines celllabels nucimagelist mtimagelist erimagelist protimagelist writelist IMAGEPIXELSIZE MINNUCLEUSDIAMETER MAXNUCLEUSDIAMETER

