function [images,masks2] = getsinglecells(image,mask)
images = [];
masks2 = [];
L = bwlabel(mask,4);

K = 1;

for I = 1:max(L(:))
	if ~checkedgecell(L==I)
		[images{K},masks2{K}] = removespace(image,L==I);
		K = K + 1;
	end
end

end
