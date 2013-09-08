% this function renders the nucleus of the cell

function render_data(some_data,clr,alphaval)

[X,Y,Z] = meshgrid(1:size(some_data,2),1:size(some_data,1),1:size(some_data,3));

p = patch(isosurface(X,Y,Z,some_data));

isonormals(X,Y,Z,some_data,p)
set(p, 'FaceColor', clr, 'EdgeColor', 'none');
daspect([1 1 1])
% view(3)
camlight; lighting phong
alpha(p,alphaval)

end
