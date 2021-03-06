function R=ml_gsmixrnd(ps,mus,covs,mm)
%ML_GSMIXRND Sampling from gaussian mixture.
%   R = ML_GSMIXRND(PS,MUS,COVS,MM) returns data sampled from a gaussian
%   mixture distribution, which is determined by PS, MUS and COVS. PS is
%   a vector the coefficients of the compoents and has the length is the
%   same as the number of components. See TZ_MNORND for more details. MS
%   is the a matrix of means of the gaussian distribution. Each column of
%   MS is the mean for a guassian. COVS is a 3D matrix of covariances for
%   the components. COVS(:,:,K) is for the Kth component. The generated
%   data has MM rows and each row is one sample.
%   
%   See also ML_MNORND

%   ??-???-???? Initial write T. Zhao
%   04-NOV-2004 Modified T. Zhao
%       - add comments
%   Copyright (c) Murphy Lab, Carnegie Mellon University

if nargin < 4
    error('Exactly 4 arguments are required')
end

nums=ml_mnornd(mm,ps,1);
R=[];
for i=1:length(nums)
    if nums(i)>0
        R=[R;mvnrnd(mus(:,i),covs(:,:,i),nums(i))];
    end
end