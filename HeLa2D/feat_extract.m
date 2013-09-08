function feat_vector = feat_extract(image,image2,featType,imgcent_coordinate,imnum,thr,numLevels1,numLevels2)
% featType: 'haralick','sliceIntensity','tas','totvolume','histogram','cubIntensity'
% image2 is the part that you want to ignore. this is exclusively for the feature compute - harIgnoreCent


if ~exist('thr','var')
   thr = 6;
end

if ~exist('numLevels1','var')
   numLevels1 = 10;
end
if ~exist('numLevels2','var')
   numLevels2 = 6;
end

if strcmp(featType,'haralick')
		feats = ml_texture_withzeros(uint8(image));
		feat_vector = feats(1:13,5)';


elseif strcmp(featType,'radIntensity')
	feat_vector = radInt(image,imgcent_coordinate);


elseif strcmp(featType,'harkd2')
		image = uint8(imresize(image,0.5));
                feats = ml_texture_withzeros(uint8(image));
                feat_vector = feats(1:13,5)';


elseif strcmp(featType,'harkd4')
		image = uint8(imresize(image,0.25));
                feats = ml_texture_withzeros(uint8(image));
                feat_vector = feats(1:13,5)';

elseif strcmp(featType,'histpropwithcent')
	image = uint8(image);
	image(find(image==0)) = [];
	feat_vector = MI_histprops(image);

elseif strcmp(featType,'histbinwithcent')
	image = uint8(image);
        image(find(image==0)) = [];
	feat_vector = MI_histin(im6);

elseif strcmp(featType,'totint')
	feat_vector = sum(image(:));


elseif strcmp(featType,'edge')
% this works only for 2D . see feat_extract.m in work30/src/ for 3d version
	image = double(uint8(image));
        feat_vector = edgecalc(image);
        image = imresize(image,0.5);
        feat_vector = [feat_vector,edgecalc(image)];
        image = imresize(image,0.5);
	feat_vector = [feat_vector,edgecalc(image)];
        
elseif strcmp(featType,'haralick2')
       addpath(genpath('/home/jieyuel/lib_backup/HPA_lib/HPA_lib/SLICfeatures/matlab'))
       feat_vector = [];
       feats = ml_texture( uint8(image) );
       feats = [mean(feats(1:13,[1 3]),2); mean(feats(1:13,[2 4]),2)]';
       feat_vector = [feat_vector, feats];

       DSF = 2;
       image = imresize(image, [size(image,1) size(image,2)]/DSF);
       feats = ml_texture( uint8(image) );
       feats = [mean(feats(1:13,[1 3]),2); mean(feats(1:13,[2 4]),2)]';
       feat_vector = [feat_vector, feats];

       image = imresize(image, [size(image,1) size(image,2)]/DSF);
       feats = ml_texture( uint8(image) );
       feats = [mean(feats(1:13,[1 3]),2); mean(feats(1:13,[2 4]),2)]';
       feat_vector = [feat_vector, feats];


elseif strcmp(featType,'histpropwithcent2')
       addpath('/home/jieyuel/lib_backup/Microtubules/nocodazole/tarball')
	image = uint8(image);
	image2 = image;
	image2(find(image2==0)) = [];
	feat_vector = MI_histprops(image2);

	image3 = image;
       DSF = 2;
	image3 = imresize(image3, [size(image3,1) size(image3,2)]/DSF);
       image3(find(image3==0)) = [];
       feat_vector = [feat_vector, MI_histprops(image3)];

	image4 = image;
       DSF = 4;
       image4 = imresize(image4, [size(image4,1) size(image4,2)]/DSF);
       image4(find(image4==0)) = [];
       feat_vector = [feat_vector, MI_histprops(image4)];


elseif strcmp(featType,'histbinwithcent2')
       addpath('/home/jieyuel/lib_backup/Microtubules/nocodazole/tarball')
	feat_vector = MI_histbin(image);


elseif strcmp(featType,'histDistLevel2')
	feat_vector = hist_DistLevel2(image,imnum,thr,numLevels1);


elseif strcmp(featType,'statDistLevel')
	feat_vector = stat_DistLevel(image,imnum,thr,numLevels1);


elseif strcmp(featType,'distHist')  %%gus
       [l_img] = getDistLevel2_gus(image,imnum,thr,numLevels2);

       m = max(l_img(:));
       feat_vector = zeros(1,m);
       for i=1:m
           ww = find(l_img == i);
           feat_vector(i) = nansum(image(ww));
           %feat_vector(i) = nanmean(image(ww));
       end


end % If ends
end % Function ends
