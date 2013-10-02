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

raw_data_files_list;
switch lower( option )
    case 'raw'
        disp( 'Recreating Results from Raw Image Data' );
        
        if ~exist( [ pwd filesep 'images' ] )
            mkdir( [ pwd filesep 'images' ] );
        end
        
        for index=1:1:length( raw_data_files )
            file = raw_data_files{index};
            if ~exist( [ pwd filesep 'images' filesep file ] );
                disp( ['Downloading file: ' file ] );
                urlwrite( [ website file ], [ pwd filesep 'images' filesep file ] );
            else
                disp( ['File ' file ' found on disk. Skipping download.'] );
            end
        end
        
        cd( [ pwd filesep 'images' ] );
        files = dir( [ pwd filesep '*.tar.gz' ] );
        for index=1:1:length(files)
            disp( ['Expanding: ' files(index).name] );
            untar( [ pwd filesep files(index).name] );
        end
        cd ..
    case 'intermediate1'
        disp('Option 1: Recreate the results from the article (i.e. the figures and tables), from intermediate results of segmented cell geometries (masks, cell and nuclear shapes)');
        for index=1:1:length( intermediate_data_files_option1 )
            file = intermediate_data_files_option1{index};
            if ~exist( [ pwd filesep file ] );
                disp( ['Downloading file: ' file ] );
                urlwrite( [ website file ], file );
            else
                disp( ['File ' file ' found on disk. Skipping download.'] );
            end
            
            untar( [ pwd filesep file ] );
        end
    case 'intermediate2'
        disp('Option 2: Recreate the results from the article (i.e. the figures and tables), from intermediate results of generated images and calculated features');
        for index=1:1:length( intermediate_data_files_option2 )
            file = intermediate_data_files_option2{index};
            if ~exist( [ pwd filesep file ] );
                disp( ['Downloading file: ' file ] );
                urlwrite( [ website file ], file );
            else
                disp( ['File ' file ' found on disk. Skipping download.'] );
            end
            
            for index=1:1:length(synthetic_images_tarballs)
                file = synthetic_images_tarballs{index};
                disp( ['Concatenating file ' file ] );
                system( [ 'cat ' file '.part-a*>' file ] );
            end
        end
    case 'intermediate3'
        disp('Option 3: Recreate the results from the article, i.e. the figures and tables, from intermediate results of all estimated model parameters');
        for index=1:1:length( intermediate_data_files_option3 )
            file = intermediate_data_files_option3{index};
            if ~exist( [ pwd filesep file ] );
                disp( ['Downloading file: ' file ] );
                urlwrite( [ website file ], file );
            else
                disp( ['File ' file ' found on disk. Skipping download.'] );
            end
        end
    otherwise
        disp( 'Unknown or unsupported option.');
end