function seg = activcon_seg(image)

% "Region Based Active Contours"
%
% Coded by: Shawn Lankton

% I = uint8(img_blind(:,:,7));  %-- load the image
% I = conv2uint(image);
I = image;
m = zeros(size(I,1),size(I,2));          %-- create initial mask
m(50:200,50:200) = 1;
seg = region_seg(I, m, 1000,0.2,false); %-- Run segmentation




