function result = mvar_gauss3d(X,Y,Z,sxy,sz,mu,c1,c2)

result = c1*(exp(-((X-mu(1)).^2 + (Y-mu(2)).^2)/(2*sxy^2))).*(c2*(exp(-((Z-mu(3)).^2)/(2*sz^2))));
