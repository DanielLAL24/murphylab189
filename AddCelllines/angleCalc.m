function angles = angleCalc(vec1, vec2)

for i = 1:size(vec1,2)
    a = vec1(:,i);
    for j = 1:size(vec2,2)
	 b = vec2(:,j);
	 angles(i,j) = atan2(norm(cross(a,b)),dot(a,b))/pi*180; % degree
    end
end 
