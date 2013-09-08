function imgcent_coordinate = esti_cent(test1,test2,mtim)
% segcell and segdna are binary images with 1 as the content and 0 as no content.

segcell = test1(:,:,1);
segdna = test2(:,:,4);
segdna_old = segdna;
segdna = imdilate(segdna,strel('disk',35)); % use 15 for 3d hela dataset
% segdna = imdilate(segdna,strel('disk',5)); % use 5 for hpa dataset

a = bwdist(binswitch(segdna));

I = 4;
e = 0;
while e <0.25
	I = I + 1;
	cc2 =imerode(segcell,strel('disk',I));
	cv=binswitch(cc2)+double(segdna);
	e = length(find(cv(find(a==1))==2))/length(find(a==1));
end
% Remove close to cell boundary regions of the nucleus
segdna(find(cv==2)) = 0;
im = (double(mtim).*double(segdna));
% imshow(uint8(im))
im = imfilter(im,fspecial('average',25));

imgcent_coordinate = search_cent_4(im);
% imshow(uint8(mtim)), hold on, plot(maxcoord(2),maxcoord(1),'*'), hold off

mf_slice = mtim(mtim~=0);
cx = mtim(imgcent_coordinate(1),imgcent_coordinate(2)); % centralslice-centrosome loc intensity
dx = max(mf_slice(:)); % max int of central slice
ex = mean(mf_slice(:)); % mean int of central slice
fx = std(mf_slice(:));
cx = cx/fx;
dx = dx/fx;
ex = ex/fx;
cent_pars = [cx,dx,ex];
b = [-0.0984;
    0.0966;
    0.1433]; % b learned from script_centrosome in work36/tarball
zcoord = cent_pars*b;
slcode = [4,3,2,1];
sldist = [0, 0.2 0.4 0.6];
[Y,I] = min(abs(repmat(zcoord,1,size(sldist,2)) - sldist));
imgcent_coordinate(3) = slcode(I);

% error correction, if not located in Dbothfin
dbothfin = double(logical(binswitch(test1) + test2));
% imshow(dbothfin(:,:,slcode(I))>0), hold on, plot(imgcent_coordinate(2),imgcent_coordinate(1),'*'), hold off
if dbothfin(imgcent_coordinate(1),imgcent_coordinate(2),imgcent_coordinate(3)) == 1
	% weighted bwdist
	eucdist = zeros(size(dbothfin));
	[cX,cY,cZ] = meshgrid(1:size(dbothfin,2),1:size(dbothfin,1),1:size(dbothfin,3));
	eucdist(:) = sqrt(sum(([0.08*(cX(:)- imgcent_coordinate(2)),0.08*(cY(:)- imgcent_coordinate(1)),0.2*(cZ(:)- imgcent_coordinate(3))]).^2,2));
	eucdist(find(dbothfin==1)) = max(eucdist(:));
	[Y,I] = min(eucdist(:));
	[imgcent_coordinate(1),imgcent_coordinate(2),imgcent_coordinate(3)] = ind2sub(size(dbothfin),I);
end



