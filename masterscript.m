function masterscript(celllineIdx, imgpath)
% This a top function to regenerate everything for the paper:
% Jieyue Li, Aabid Shariff, Mikaela Wiking, Emma Lundberg, Gustavo K. Rohde and Robert F. Murphy. 
% Estimating microtubule distributions from 2D immunofluorescence microscopy images reveals differences 
% among human cultured cell lines. PLoS ONE (2012). 

% Author: Jieyue Li
%
% Copyright (C) 2012 Murphy Lab
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

if ~exist('celllineIdx', 'var') || isempty(celllineIdx)
   % which cell line(s) we will use, 0 - Hela, 1 - HPA:A-431, 2 - HPA:U-2OS, 3 - HPA:U-251MG, 4 - HPA:RT-4, 5 - HPA:PC-3, 6 - HPA:Hep-G2, 7 - HPA:HeLa, 8 - HPA:CaCo2, 9 - HPA:A-549, 10 - HPA:Hek-293, 11 - HPA:MCF-7 
   celllineIdx = 0:11;
end

if ~exist('imgpath','var')
   imgpath = [ pwd filesep 'images' ];  % use the default image path(es) in images/
end


%clear all
%close all

addpath(genpath( './lib/SLIC/' ));
addpath([pwd filesep 'HPA2D/slicfiles/']);


for Idx = celllineIdx(:)'

if Idx == 0
% 3D HeLa, generate microtubules and estimate model parameters using directly 3D HeLa cells
cd HeLa3D
raw2proc_hela_script  % preprocess images
auto_segment_hela_script  % segment images into cells
process_seg_hela_script  % preprocess cells to get cell geometries (cell shapes and nuclear shapes)
scriptx_new  % estimate single microtubule intensity
all_script_script  % generate microtubule distributions
extract_features_script  % extract features for generated synthetic cells
getallcellsfeatvec  % extract features for real cells
recover_parameters_from_real_image_ownlib_script  % estimate model parameters indirectly
cd ..


% 2D HeLa
%generate microtubules and estimate model parameters using approximated 3D cell geometries generated from 2D HeLa central slices
addpath('./HPA2D/slicfiles/');
cd HeLa2D, 
scriptx_new
script_loadimage  % preprocess 2D central slices to get 3D cell geometries (cell shapes and nuclear shapes)
all_script_script
extract_features_script
getallcellsfeatvec
recover_parameters_from_real_image_ownlib_script
compare2d3d  % compare the results of model parameters from using directly 3D HeLa cells or 2D central slices
cd ..

end  % end if


if Idx>=1 && Idx<=3
% 2D HPA
addpath(genpath('./lib/HPA_lib/SLICfeatures/matlab'));
addpath(genpath('./lib/HPA_lib/segmentation'));
addpath(genpath('./lib/HPA_lib/CalcFeatures'));
addpath('./lib/HPA_lib/system');
cd HPA2D, generate microtubules and estimate model parameters using approximated 3D cell geometries generated from 2D HPA images (3 cell lines)
script_segmentation(imgpath)  % segment image fields into single cells
scriptx_new % extrapolate 3D PSF
script_loadimage_script_script(Idx,imgpath) % generate the data
script_getmean_mtint % estimate single mt intensity
all_script_script(Idx)  % generate synthetic images
extract_features_script(Idx)  % feature calculation
wrap_features_script(Idx)  % wrap the calculated individual features together
getallcellsfeatvec_hpa  % calculate features for all real images
recover_parameters_from_real_image_ownlib_script_script(Idx)

if Idx==3
all_script_script_syn  % generate synthetic images
extract_features_script_syn  % feature calculation
wrap_features_script_syn  
recover_parameters_from_real_image_ownlib_script_script_syn
end

cd ..

end  % end if


if Idx>=4 && Idx<=11
% 2D AddCelllines, generated microtubules and estimate model parameters using approximated 3D cell geometries generated from 2D HPA images (more 8 cell lines)
addpath(genpath('./HPA2D/slicfiles'));
addpath(genpath('./lib/HPA_lib/SLICfeatures/matlab'));
addpath(genpath('./lib/HPA_lib/segmentation'));
cd ./AddCelllines
wrap_allimages(Idx)  % wrap information of all images of additional cell lines
scriptx_new % extrapolate 3D PSF
script_getmean_mtint % estimate single mt intensity 
getallcellsfeatvec_hpa

script_loadimage_script_script(Idx,imgpath)
all_script_script(Idx)  % generate synthetic images
extract_features_script(Idx)  % feature calculation
wrap_features_script(Idx)  
recover_parameters_from_real_image_ownlib_script_script(Idx)
cd ..

end  % end if

end  % end for Idx = celllineIdx(:)'


if sum(abs(unique(celllineIdx) - [0:11])) == 0
%% regenerate results of tables and figures in the paper

regenResults

end  % end if

