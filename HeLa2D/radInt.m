function feat_vec2 = radInt(image2, imgcent_coordinate)

% The intensity starts only away from the centrosome.
% I will take only the first five.

size_x = size(image2,1);
size_y = size(image2,2);


[cX,cY] = meshgrid(1:size_x,1:size_y);
eucdist = sqrt(sum(([cX(:)- imgcent_coordinate(1),cY(:)- imgcent_coordinate(2)]).^2,2));

% ranges = ceil(14:(max(eucdist)-14)/10:(max(eucdist)+14));

ranges = [0, 15, 50:50:600];
feat_vec2 = zeros(size(ranges));

for I = 1:size(ranges,2)-1 % The default value is -1 instead of -6. Chose 6 because I want it to be tight.
	rIndices = find((eucdist>ranges(I)).*(eucdist <= ranges(I+1)));
	if size(rIndices,1) ~= 0 
		feat_vec2(I) = sum(image2(rIndices))/size(rIndices,1);
	end
end
