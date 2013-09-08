function script_loadimage(setno,fieldno,thr,dataloc1,dataloc2)

load HPAimagelist2.mat celllabels nucimagelist mtimagelist erimagelist protimagelist writelist
masklist = writelist;
imagelist = nucimagelist;

ilist = find(celllabels==setno);

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

[improt,immt,imnuc,mask] = getFieldImage(ilist2(fieldno),nucimagelist,mtimagelist,protimagelist,masklist,dataloc1,dataloc2);

[images2,masks2] = getsinglecells(immt,mask);
[dnas] =  getsinglecells(imnuc,mask);

for I = 1:size(images2,2)
	images2{I} = imresize(images2{I},0.08013/0.2);
	masks2{I} = imresize(masks2{I},0.08013/0.2);
	dnas{I} = imresize(dnas{I},0.08013/0.2,'nearest');
end

mpts = [];
dbothfins = {};
segdnatemp = {};
mm = {};

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
	if mm{J}(3) > thr, mm{J}(3) = thr; end
	% add mt intensity here
	cc = segdna2(:,:,4);
	cc = imerode(cc,se);
	imslice = cc.*images2{J};
	
	mpts(J) = secondderest(imslice,1,3);
end

mpts(1:end) = mean(mpts);
images = [images,images2];
mints = [mints,mpts];
centcoords = [centcoords,mm];
Dbothfins = [Dbothfins,dbothfins];
segdnas = [segdnas,segdnatemp];
no_of_cells = size(images,2);


XYZres = [0.2 0.2 0.2];

jh = 0;% I want these cells to take numbers 1 to 11
if size(images,2) > 0
for imnum = 1:size(images,2)
	imgcent_coordinate = centcoords{imnum};
	Dbothfin = Dbothfins{imnum};
	segdna = segdnas{imnum};
%	segcell = segcells{imnum};
	protim3 = images{imnum};
	mint = mints(imnum);
       if ~exist(['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(imnum+jh)])
	mkdir(['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(imnum+jh)]);
       end
	save(['proc_' num2str(thr) '/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(imnum+jh) '/final_info.mat'],'Dbothfin','imgcent_coordinate','XYZres','mint','segdna','protim3','fieldno','no_of_cells');
end

end % end of if

end % end of function
