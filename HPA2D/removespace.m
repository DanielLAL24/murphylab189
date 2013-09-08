function [image,mask2] = removespace(image,mask)

mask = double(mask);
image = mask.*double(image);

coHor = find((conv(double(sum(mask,1)~=0),[1 1])) == 1);
coVer = find((conv(double(sum(mask,2)~=0)',[1 1])) == 1);
image([1:coVer(1)-1,coVer(2)+1:end],:,:) = [];
image(:,[1:coHor(1)- 1,coHor(2)+1:end],:) = [];
mask2 = mask;
mask2([1:coVer(1)-1,coVer(2)+1:end],:,:) = [];
mask2(:,[1:coHor(1)- 1,coHor(2)+1:end],:) = [];


end
