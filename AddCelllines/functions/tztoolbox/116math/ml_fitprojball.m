function para = ml_fitprojball(x,y)
%ML_FITPROJBALL Fit ball projection.
%   PARA = ML_FITPROJBALL(X,Y) returns the parameter of ball projection.
%   
%   See also

%   28-Sep-2006 Initial write T. Zhao
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
    error('Exactly 2 arguments are required');
end

% [para,resid]=lsqcurvefit(@tz_projball,[10,1,1], ...
%     x,y,[0,0,1],[Inf,Inf,Inf]);
% [para,resid]=lsqcurvefit(@tz_projball,para, ...
%     x,y,[0,0,1],[Inf,Inf,Inf]);

% [para,resid]=lsqcurvefit(@tz_projball,[10,1], ...
%     x,y,[0,0],[Inf,Inf]);
% [para,resid]=lsqcurvefit(@tz_projball,para, ...
%     x,y,[0,0],[Inf,Inf]);

[para,resid]=lsqcurvefit(@tz_projball,[10,1 1], ...
    x,y,[0,0 0],[Inf,Inf Inf]);
[para,resid]=lsqcurvefit(@tz_projball,para, ...
    x,y,[0,0 0],[Inf,Inf Inf]);
