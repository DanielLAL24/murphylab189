#!/bin/bash

# Author: Ivan E. Cao-Berg (icaoberg@scs.cmu.edu)
#
# Copyright (C) 2012 Murphy Lab
# Lane Center for Computational Biology
# School of Computer Science
# Carnegie Mellon University
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 2 of the License,
# or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
#
# For additional information visit http://murphylab.web.cmu.edu or
# send email to murphy@cmu.edu

wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_A431.tar.gz
wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_A549.tar.gz
wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_CaCo.tar.gz
wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_Hek293.tar.gz
wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_HeLa.tar.gz
wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_HepG2.tar.gz
wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_MCF7.tar.gz
wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_PC3.tar.gz
wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_RT4.tar.gz
wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_U251MG.tar.gz
wget -nc http://murphylab.web.cmu.edu/software/2012_PLoS_ONE_Microtubule_Models/CellLines_rawdataHPA_U2OS.tar.gz

mkdir ./images
mv CellLines*.tar.gz ./images
cd ./images

for FILE in *rawdata*.tar.gz
do
 tar -xzvf "$FILE"
 rm -f "$FILE"
done
