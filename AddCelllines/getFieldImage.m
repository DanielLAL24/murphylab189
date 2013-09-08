function [improt,immt,imnuc,mask] = getFieldImage(fieldIdx,nucimagelist,mtimagelist,protimagelist,masklist,dataloc1,dataloc2)

I = fieldIdx;

protfilename = protimagelist{I};
mtfilename = mtimagelist{I};
nucfilename = nucimagelist{I};
maskfilename = masklist{I};

if exist('dataloc1','var') && ~isempty(dataloc1)
   mtfilename = regexprep(mtfilename, '/home/jieyuel/lib_backup/data/AdditionalCelllineImages', dataloc1);  % decide the location of the data (images)
   nucfilename = regexprep(nucfilename, '/home/jieyuel/lib_backup/data/AdditionalCelllineImages', dataloc1);
   protfilename = regexprep(protfilename, '/home/jieyuel/lib_backup/data/AdditionalCelllineImages', dataloc1);
end

if exist('dataloc2','var') && ~isempty(dataloc2)
   cc = regexprep(cc, '/home/jieyuel/lib_backup/data/AdditionalCelllineImages', dataloc2);  % decide the location of the segmented masks
end

improt = [];
if ~isempty(protfilename)
improt = double(imread(protfilename)); improt = sum(improt,3);  %improt = improt/max(max(improt)) * 255;  %% 16bit image
if max(max(improt))>255  improt = improt/(2^16-1)*255;  end  %% 16bit image
end
immt = double(imread(mtfilename)); immt = sum(immt,3);  %immt = immt/max(max(immt)) * 255;  %% 16bit image
if max(max(immt))>255  immt = immt/(2^16-1)*255;  end  %% 16bit image
imnuc = double(imread(nucfilename)); imnuc = sum(imnuc,3);  %imnuc = imnuc/max(max(imnuc)) * 255;  %% 16bit image
if max(max(imnuc))>255  imnuc = imnuc/(2^16-1)*255;  end  %% 16bit image
mask = imread(maskfilename);

end % End of function
