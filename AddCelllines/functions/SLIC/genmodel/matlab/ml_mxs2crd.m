function pts = ml_mxs2crd(medaxis,width)
%ML_MXS2CRD Convert medial axis shape to coordinates
%   PTS = ML_MXS2CRD(MEDAXIS,WIDTH) returns an array of points which are
%   represented by the medial axis shape with medial axsi MEDAXIS ans width
%   WIDTH.
%   
%   See also

%   30-Dec-2005 Initial write T. Zhao
%   Copyright (c) Center for Bioimage Informatics, CMU

if nargin < 2
    error('Exactly 2 arguments are required')
end

pts1(:,1) = medaxis(:,1);
pts1(:,2) = medaxis(:,2)-floor(width'/2); % **^*

pts2(:,1) = medaxis(:,1);
pts2(:,2) = medaxis(:,2)+floor(width'/2-0.5); % **^*

pts = [pts1;flipud(pts2)];
pts(end+1,:) = pts(1,:);
