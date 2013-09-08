function valuez = edgecalc(imageproc)
%
A = bwarea(edge(imageproc,'canny',[]))/bwarea(im2bw(imageproc)) ;
if isinf(A)
	A = 0;
end

N = [1 1 1 ; 0 0 0 ; -1 -1 -1] ;
W = [1 0 -1 ; 1 0 -1 ; 1 0 -1] ;

%
% Calculation of the gradient from two orthogonal directions
%
iprocN = filter2(N,imageproc) ;
iprocW = filter2(W,imageproc) ;

%
% Calculate the magnitude and direction of the gradient
iprocmag = sqrt(iprocN.^2 + iprocW.^2) ;
iproctheta = atan2(iprocN, iprocW) ;
iproctheta(find(iproctheta==-pi))=pi;

%
nonzero = find(iprocmag);
v = iproctheta(nonzero);
v_mag = iprocmag(nonzero);


% Remove zeros from the computation of the features

nonzero = find(iprocmag);
v = iproctheta(nonzero);
v_mag = iprocmag(nonzero);


% Edge direction features
h = hist(v,8);
% max/min ratio
[hmax maxidx] = max(h) ;
hmin = min(h);

if (hmin ~= 0),
  maxminratio = hmax/hmin ;
else
  maxminratio = 0 ;
end

htmp=h ;
htmp(maxidx) = 0 ;
hnextmax = max(htmp) ;
maxnextmaxratio=hmax/hnextmax ;

diff = abs(h(1:4)-h(5:8))./abs(h(1:4)+h(5:8));
diff(abs(h(1:4)-h(5:8))==0) = 0;

sumdiff=sum(diff) ;

% Edge magnitude features
h_mag = hist(v_mag,4);
homogeneity = sum(h_mag(1))/sum(h_mag(:)) ;


valuez(1) = sum(v_mag(:))/sum(imageproc(:));
valuez(2) = std(v_mag(:))/sum(imageproc(:));
valuez = [valuez, A homogeneity maxminratio maxnextmaxratio sumdiff];


end % End of function
