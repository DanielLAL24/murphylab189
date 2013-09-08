function [mpts] = script_estimate_mtint(setno,fieldno,dataloc1,dataloc2)



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

if ~exist('dataloc1','var')
   dataloc1 = [];
end
if ~exist('dataloc2','var')
   dataloc2 = [];
end

[improt,immt,imnuc,mask] = getFieldImage(ilist2(fieldno),imagelist,dataloc1,dataloc2);

[images2,masks2] = getsinglecells(immt,mask);
[dnas] =  getsinglecells(imnuc,mask);
mpts = [];
dbothfins = {};
segdnatemp = {};
mm = {};
for J = 1:size(images2,2)
	tempsegdna2 = nuc_structure_det(dnas{J});
	segcell = binswitch(cell_structure_det(images2{J}));
	segdna2 = zeros(size(segcell));
	segdna2(:,:,2:7) = tempsegdna2;
	segdnatemp{J} = segdna2;
	
		
	% add mt intensity here
	cc = segdna2(:,:,4);
	cc = imerode(cc,se);
	imslice = cc.*images2{J};
		
	mpts = [mpts,secondderest(imslice,1,3)];
end

end % End of function
