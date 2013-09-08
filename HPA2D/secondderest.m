function [mint] = secondderest(imslice,sig,thresh)

% sig = 3;
% thresh = 1000;

[Dxx,Dxy,Dyy] = Hessian2D(double(imslice),sig);
[Lambda1,Lambda2]=eig2image(Dxx,Dxy,Dyy);
% a = abs(Lambda2)./abs(Lambda1);
a = abs(Lambda1); 
b = zeros(size(a));
cc = find(a(:)>=thresh);
b(cc) = a(cc);
% finim(:,:,1) = 255*uint8(b>0); finim(:,:,3) = imslice; imshow(finim)

a2 = imslice(cc);
pfint = mean(a2(a2~=0));
% [Y,I] = hist(double(a2(a2~=0)),40); [YY,II] = max(Y); pfint = I(II); % the median version

mint = pfint;
