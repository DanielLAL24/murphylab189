function finalimage = nuc_structure_det(protim3)


%  input here is the binary image
im = nucleus_threshold(protim3);


% Here are all the total sums to be generated:
% totfracs = [0.9115, 0.9606, 1.0000, 0.9570, 0.8148, 0.7013];
totfracs = [1.0000, 0.9570, 0.8148, 0.7013, 0.7013, 0.7013];
totalsums = sum(im(:))*totfracs;

% compute the transform
bwV = bwdist(binswitch(im));

dists = [0:0.5:100]';
asds = zeros(size(dists));
for I = 1:size(dists,1), asds(I) = sum(sum(bwV>dists(I))); end

for sliceno = [1:6]
	[Y,I] = min(abs(asds - repmat(totalsums(sliceno),size(asds,1),1)));
	finalimage(:,:,sliceno) = (bwV>dists(I));
end
end % End of function
