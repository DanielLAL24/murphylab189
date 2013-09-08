function finalimage = cell_structure_det(protim3)


p = imfill(protim3>0,'holes');

% The structure of the cell is based on morphing the membrane boundary to an elliptical boundary
% First, we will generate an outer ellipse bounding the binary cell shape.
s = regionprops(bwlabel(p), 'Orientation', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity','Centroid', 'Area');

% Find the object of interest
for I = 1:size(s,1), temp_Area(I) = s(I).Area; end
k = find(temp_Area == max(temp_Area));

% Fit an ellipse around the object

ellipim = fitellipse(s,k,protim3);

% Reduce size of ellipse to fit inside the membrane (object)
im = bwlabel(p)==k;

tempim = im.*ellipim;

while sum(ellipim(:)) > sum(tempim(:))
	ellipim = imerode(ellipim,strel('disk',1));
	tempim = im.*ellipim;
end

% Here are all the total sums to be generated:
totalsums = sum(im(:))*(2.^-(0:(2/7):2));

% Bring it to size at the mid part (along z) of cell
while totalsums(4) < sum(ellipim(:))
	ellipim = imerode(ellipim,strel('disk',1));
end

% Store
V(:,:,1) = im;
V(:,:,2) = ellipim;

% Modeled the cell membrane sum intensity as y = a.2^(-2)
% Now we will interpolate whatever slices needed based on the intensities modeled as above.
% sumint = sum(im(:))*2.^(-(0:0.5:2));

for I = 1:2
	bwV(:,:,I) = bwdist(binswitch(V(:,:,I))); 
end

[XI,YI,ZI] = meshgrid(1:size(ellipim,2),1:size(ellipim,1),1:3);
[X,Y,Z] = meshgrid(1:size(ellipim,2),1:size(ellipim,1),[1,3]);

VI = interp3(X,Y,Z,bwV,XI,YI,ZI,'linear');

% Now that we have interpolated the mid slices (2 and 4 for range 1:5),
% I will use 2 to make (2, 3) and 4 to make (5,6,7) for range 1:8

% dists = unique(VI(:,:,2)); dists(dists<0) =[];
dists = [0:0.5:100]';
asds = zeros(size(dists));
for I = 1:size(dists,1), asds(I) = sum(sum(VI(:,:,2)>dists(I))); end

finalimage(:,:,1) = V(:,:,1);
for sliceno = [2:8]
	[Y,I] = min(abs(asds - repmat(totalsums(sliceno),size(asds,1),1)));
	finalimage(:,:,sliceno) = (VI(:,:,2)>dists(I));
end

end % End of function

function ellipim = fitellipse(s,k,protim3) % local function

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);

xbar = s(k).Centroid(1);
ybar = s(k).Centroid(2);

a = s(k).MajorAxisLength/2;
b = s(k).MinorAxisLength/2;

theta = pi*s(k).Orientation/180;
R = [ cos(theta)   sin(theta)
      -sin(theta)   cos(theta)];

xy = [a*cosphi; b*sinphi];
xy = R*xy;

x = xy(1,:) + xbar;
y = xy(2,:) + ybar;

y(find(y>=size(protim3,1))) = size(protim3,1)-1;
x(find(x>=size(protim3,2))) = size(protim3,2)-1;

y(find(y<1)) = 1;
x(find(x<1)) = 1;

ellipim = uint8(zeros(size(protim3)));
for I = 1:size(x,2)
        ellipim(round(y(I)),round(x(I))) = 1;
end
ellipim = ml_imgconvhull(ellipim);

end
