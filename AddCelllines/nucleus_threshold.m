function imnuc4 = nucleus_threshold(imnuc)

%imnuc3= imfill(imnuc>0,'holes');
%se4 = strel('disk',7);
%imnuc4 = imerode(imnuc3,se4);

se4 = strel('disk',7);
imnuc3 = imopen(imnuc, se4);
imnuc4 = imfill(imnuc3>0, 'holes');

end
