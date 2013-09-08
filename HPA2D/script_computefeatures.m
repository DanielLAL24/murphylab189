function [feat_vec,keys] = script_computefeatures(setno,fieldno)

thr = 8;

load HPAimagesList.mat cellabels imagelist

ilist = find(cellabels==setno);

% Get the unique field images
stringprev = imagelist{ilist(1)};
ilist2(1) = ilist(1);
KK = 2;
for I = ilist'
        stringcurr = imagelist{I};
        if strcmp(stringcurr,stringprev) == 0
                ilist2(KK) = I;
                stringprev = stringcurr;
                KK = KK +1;
        end
end

images = {}; masks = {}; Dbothfins = {}; mints = []; segdnas = {}; centcoords = {};
se = strel('disk',15);

[improt,immt,imnuc,mask] = getFieldImage(ilist2(fieldno),imagelist);

[images2,masks2] = getsinglecells(immt,mask);
[dnas] =  getsinglecells(imnuc,mask);

for I = 1:size(images2,2)
	images2{I} = imresize(images2{I},0.4);
	masks2{I} = imresize(masks2{I},0.4);
	dnas{I} = imresize(dnas{I},0.4,'nearest');
end

mpts = [];
dbothfins = {};
segdnatemp = {};
mm = {};
feat_vec = [];
keys = [];

for J = 1:size(images2,2)
	tempsegdna2 = nuc_structure_det(dnas{J});
	segcell = binswitch(cell_structure_det(images2{J}));
	segdna2 = zeros(size(segcell));
	segdna2(:,:,2:7) = tempsegdna2;
	segdna2(:,:,thr:7) = [];
	segcell(:,:,thr:7) = [];
	dbothfins{J} = double(logical(segcell + segdna2));
	segdnatemp{J} = segdna2;
	% add centrosome detect here
	mm{J} = esti_cent(binswitch(segcell),segdna2,images2{J});
	if mm{J}(3) > thr
		mm{J}(3) = thr;
	end
	feat_vec(J,:) = real_im_feat_extract(images2{J},mm{J});
	keys(J,:) = [setno, fieldno, J];
end

end % end of function
