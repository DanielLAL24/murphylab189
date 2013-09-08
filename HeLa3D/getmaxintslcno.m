function II = getmaxintslcno(image)

for I = 1:size(image,3)
	df(I) = sum(sum(image(:,:,I)));
end

[Y,II] = max(df);

end
