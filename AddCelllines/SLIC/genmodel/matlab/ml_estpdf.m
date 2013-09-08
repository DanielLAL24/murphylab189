function f2 = ml_estpdf(x,f,param)
%ML_ESTPDF Estimate the distribution from data.
%   F2 = ML_ESTPDF(X,F) returns a [pdf], which is the estimation of the
%   [partial pdf] F on data X. If it is a univariate distribution, X must
%   be a column vector. If it is a multivariate distribution, X must be a
%   [feature matrix].
%   Notice: Although F.transform is usually a [general function], there is
%   one exception. F.transform will do PCA transformation when the name is
%   '_pca'. The number of PCA components can be specified by the field
%   'ncomp' in F.transform.param.
%   
%   F2 = ML_ESTPDF(X,F,PARAM) specifies how to estimate the distribution.
%   PARAM is a structure. Currently it is only available for the 'mvn' pdf.
%   If F.name is 'mvn', then PARAM has the following field:
%       'tz_estcov' - the parameter for TZ_ESTCOV, which is used to
%           estimate the covariance matrix. This is only useful when the
%           [pdf] F has no known parameters.
%
%   See also ML_PDF ML_RND

%   03-Aug-2006 Initial write T. Zhao
%   Copyright (c) 2006 Murphy Lab
%   Carnegie Mellon University
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published
%   by the Free Software Foundation; either version 2 of the License,
%   or (at your option) any later version.
%   
%   This program is distributed in the hope that it will be useful, but
%   WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%   General Public License for more details.
%   
%   You should have received a copy of the GNU General Public License
%   along with this program; if not, write to the Free Software
%   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
%   02110-1301, USA.
%   
%   For additional information visit http://murphylab.web.cmu.edu or
%   send email to murphy@cmu.edu


if nargin < 2
    error('At least 2 arguments are required');
end

if ~exist('param','var')
    param = struct([]);
end

if isfield(f,'transform')
    if strcmp(f.transform.funname,'_pca')
        f.transform.funname = 'ml_linfun';
        f.transform.param.scale = princomp(x);
        if isfield(f.transform,'param')
            if isfield(f.transform.param,'ncomp')
                f.transform.param.scale = ...
                    f.transform.param.scale(:,1:f.transform.param.ncomp);
                rmfield(f.transform.param,'ncomp');
            end
        end
        f.transform.param.offset = -mean(x)*f.transform.param.scale;   
    end
    x = ml_evalfun(x,f.transform);
end

switch f.name
    case 'norm' %normal distribution
        if ~isfield(f,'mu') & ~isfield(f,'sigma')
            [f.mu,f.sigma] = normfit(x);
        else
            if ~isfield(f,'mu')
                f.mu = mean(x);
            end

            if ~isfield(f,'sigma')
                f.sigma = sqrt(sum((x-f.mu).^2)/(length(x)-1));
            end
        end
    case 'mvn' %multivariate norml distribution
        if ~isfield(f,'mu') & ~isfield(f,'sigma')
            param = ml_initparam(param, struct('tz_estcov', ...
                struct('method','mle')));
            f.mu = mean(x,1);
            f.sigma = ml_estcov(x,param.tz_estcov);
        else
            if ~isfield(f,'mu')
                f.mu = mean(x);
            end

            if ~isfield(f,'sigma')
                f.sigma = ml_cov(x,0,[],f.mu);
            end
        end    
    case 'gamma'
        parmhat = gamfit(x);
        f.alpha = parmhat(1);
        f.beta = parmhat(2);
    case 'exp'
        f.beta = expfit(x);
    case 'hist'
        [f.hist,occ1,occ2] = unique(x,'rows');
        f.hist(:,end+1) = ml_countnum(occ2)'/size(x,1);
    case 'mix'
        switch param.mixname
            case 'gmm' %gaussian mixture
                f = ml_gmmfit(x,param);
            otherwise
                error('Unrecognized mixture model name');
        end
        
    otherwise
        error('Unrecognized pdf.');
end

f2 = f;
