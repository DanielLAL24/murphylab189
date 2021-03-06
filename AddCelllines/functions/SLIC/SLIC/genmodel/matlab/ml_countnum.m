function [n,range] = ml_countnum(x)
%ML_COUNTNUM Count integers in a vector.
%   N = ML_COUNTNUM(X) returns a vector which contains the number of integers
%   occurring in the vector X, which contains integers. n(1) is the number of
%   the minmum in X and n(end) is the number of maxmum in X. 
%   
%   [N,RANGE] = ML_COUNTNUM(X) also returns the range of X.
%    
%   See also

%   28-May-2006 Initial write T. Zhao
%   Copyright (c) Center for Bioimage Informatics, CMU

if nargin < 1
    error('Exactly 1 argument is required')
end

range(1) = min(x);
range(2) = max(x);

n = hist(x,range(2)-range(1)+1);
