function objects=ml_findobjs(imageproc)
%ML_FINDOBJS Find objects in an image.
%   OBJECTS = ML_FINDOBJS(IMGPROC) returns a cell array of objects. Each
%   object is a 3-column matrix with each row [X, Y, gray level]. Any
%   value less than 1 in IMGPROC will be considered as background.

%   ??-???-???? Initial write T. Zhao
%   Copyright (c) Murphy Lab, Carnegie Mellon University

if nargin < 1
    error('Exactly 1 argument is required')
end

objects=[];

imagemask=im2bw(imageproc);
imagelabeled=bwlabel(imagemask);
obj_number=max(imagelabeled(:));
imgsize=size(imageproc);
for i=1:obj_number
    [r,c]=find(imagelabeled==i);
    
    objects{i}=[r,c,imageproc((c-1)*imgsize(1)+r)];
end

