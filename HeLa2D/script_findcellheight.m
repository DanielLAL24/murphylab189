clear all
close all
I = 1;

cellnums = [1 2 4 6 10 12:42 46:49 51:52];

for cellnum = cellnums
	[a,b,segdna,segcell] = getrealimage_hela(cellnum);
	c = [];
	sizelength(I) = size(a,3);
	c(:,:) = sum(sum(segcell));
	hts(I) = length(find(c~=0));
	d = find(c>0);
	as{I} = c(c~=0);
	center_slice(I) = d(floor(length(find(c>0))/2));
	three_slices(I,:) = [as{I}(1), c(center_slice(I)), as{I}(end)];
	three_slices(I,:) = three_slices(I,:)./as{I}(1);
	I = I + 1;
end

% for the numbers that have ht = 8
J = 1;
for I = find(hts==8)
	red_as(J,:) = as{I};
	J = J + 1;
end
red_as = red_as./repmat(red_as(:,1),1,size(red_as,2));
plot(mean(red_as),'-*'), hold on
plot(2.^-(0:(2/7):2),'-*r'), hold off
legend('Est','Model')
xlabel('Slice number')
ylabel('Scaled slice area')
title('SLICE AREA')
