function [improt,immt,imnuc,mask] = getFieldImage(fieldIdx,imagelist,dataloc1,dataloc2)

I = fieldIdx;
protfilename = imagelist{I};
mtfilename = imagelist{I};
mtfilename(end-8:end) = '';
mtfilename = [mtfilename 'red.tif'];
nucfilename = imagelist{I};
nucfilename(end-8:end) = '';
nucfilename = [nucfilename 'blue.tif'];
cc = protfilename;

mtfilename = mtfilename(14:end);
nucfilename = nucfilename(14:end);
protfilename = protfilename(14:end);

mtfilename = ['/share' mtfilename];
nucfilename = ['/share' nucfilename];
protfilename = ['/share' protfilename];

if exist('dataloc1','var') && ~isempty(dataloc1)
   mtfilename = regexprep(mtfilename, '/share/images/HPA/images', dataloc1);  % decide the location of the data (images)
   nucfilename = regexprep(nucfilename, '/share/images/HPA/images', dataloc1);
   protfilename = regexprep(protfilename, '/share/images/HPA/images', dataloc1);
end

improt = imread(protfilename);
immt = imread(mtfilename);
imnuc = imread(nucfilename);

cc(1:42) = '';
idx = find(cc=='/');
cc(idx(2)) = '_';
cc = ['/share/home/jieyuel/images/HPA/images/data/masks',cc];
cc(end-2:end) = 'png';

if exist('dataloc2','var') && ~isempty(dataloc2)
   cc = regexprep(cc, '/share/home/jieyuel/images/HPA/images', dataloc2);  % decide the location of the segmented masks
end

mask = imread(cc);

end % End of function
