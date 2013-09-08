function maxcoord = search_cent_4(image)

tubimg = double(image);

% use the averaging filter
% B = (1/(3*3*3))*ones(3,3,3);

% A = convn(tubimg,B,'same');

for i = 1: size(tubimg,3)
    [Y, I] = max(tubimg(:,:,i));
    [YY, II] = max(Y);
    maxinslice(i,:) = [I(II),II];
    maxval(i) = tubimg(maxinslice(i,1), maxinslice(i,2),i);
end

[Y,I]=max(maxval);

maxcoord = [maxinslice(I,1), maxinslice(I,2), I];

% imshow(uint8(tubimg)), hold on, plot(maxcoord(2),maxcoord(1),'*'), hold off

end
