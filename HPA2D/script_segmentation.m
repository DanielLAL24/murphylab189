close all
clear all

%% run to segment images.
% function segmentFields(readdir,writedir)
% readdir - the root directory contains all the images;
% writedir - the directory to write the segmentation masks.

readdir = '../images/HPA/images/IFconfocal/';  % location for HPA images, e.g. readdir = './images/HPA/images/IFconfocal/';
writedir = '../images/HPA/images/data/masks/';  % location for segmentation masks

segmentFields(readdir, writedir);

