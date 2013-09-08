function [el,xy,IN] = ellipse(xx,var,sd,points,varargin);

if ~exist('sd','var') || isempty(sd)
   sd = 1;
end

[v,d] = eig(var);
d = sqrt(d)*sd;
theta = -.05 :.05: 2*pi;
xy = repmat(xx,1,length(theta))+...
     d(1,1)*v(:,1)*sin(theta)+d(2,2)*v(:,2)*cos(theta);
el = plot(xy(1,:),xy(2,:),varargin{:});


%% check points inside or outside the ellipse
IN = inpolygon(points(1,:),points(2,:),xy(1,:),xy(2,:));
