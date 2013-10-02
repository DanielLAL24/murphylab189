function answer = run( option )

% Author: Ivan E. Cao-Berg (icaoberg@scs.cmu.edu)
%
% Copyright (C) 2013 Murphy Lab
% Lane Center for Computational Biology
% School of Computer Science
% Carnegie Mellon University
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published
% by the Free Software Foundation; either version 2 of the License,
% or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
% 02110-1301, USA.
%
% For additional information visit http://murphylab.web.cmu.edu or
% send email to murphy@cmu.edu

if nargin == 0
    option = 'raw';
end

switch lower( option )
    case 'raw'
        raw_data_files_list;
        for index=1:1:length( raw_data_files )
            file = raw_data_file{index};
            if ~exist( [ pwd filesep file ] );
            disp( ['Downloading file: ' file ] );
            urlwrite( [ website file ] );
        else
            disp( ['File ' file ' found on disk. Skipping download.'] );
        end
    otherwise
end