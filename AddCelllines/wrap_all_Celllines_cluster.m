close all
clear all

% wrap all estimated parameters for all the cell lines (3 major and 8 added).
% 3 parameters: n - number of microtubules;
%		  mu - mean length of microtubule;
%		  cosa - collinearity.
% we may only use the first two parameters ( n and mu ).


finTable_all = [];
keys_all = [];
thr_all = [];


% load the estimates for the 3 major cell lines (from feature matching in the library).
w = [0,0,0,0,1,1,1,1,1,0,0,0,0];

%subfolder = 2;
subfolder = 3;

%{
for setno = 1:3
	load(['../HPA2D/outputs_',num2str(subfolder),'/results/set_',num2str(setno),'/result_new_',regexprep(num2str(w),'  ','_'),'.mat'],'finTable');
       finTable_all = [finTable_all; double(finTable)];
end
keys_all = finTable_all(:,[end-2:end]);
finTable_all = finTable_all(:,[1,2,4]);
%}
load(['../HPA2D/predict_simulate_allfeatures2_w5_s',num2str(3),'.mat_SpAM.mat'], 'finTable_all','keys_all');


% load the estimates for the added 8 cell lines (from regression prediction trained on the 3 major cell lines).
%load predict_allrealfeats_allfeats_allsetsw5.mat_SpAM.mat
load predict_allrealfeats_allfeats_allsetsw5.mat_s3_SpAM.mat

finTable_all = [finTable_all; double(finTable)];
keys_all = [keys_all; double(keys)];




%% calculate the area of the cell (cytoplasm) that can generate microtubules (i.e. Dbothfin)
addpath(genpath('./mytoolbox/'));
area_Dbothfin = [];
area_dna = [];
area_segcell = [];
major_Dbothfin = [];
major_segcell = [];
vol_Dbothfin = [];
realMT = [];
keys_all2 = [];
areaD = [];
volD = [];

currentdir = pwd;
cd ../HPA2D
fieldnos{1} = 1:16;
fieldnos{2} = 1:30;
fieldnos{3} = 1:16;
cellnums = [1:50];
for setno = 1:3  
	for fieldno = fieldnos{setno}
		for imnum = cellnums
			disp([setno, fieldno, imnum]);
			myfile = ['proc_6/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(imnum) '/final_info.mat'];
			if (exist(myfile,'file') == 2)
				[protim3,Dbothfin,segdna,imgcent_coordinate] = getrealimage_hpa(setno,fieldno,imnum);
				area_Dbothfin = [area_Dbothfin; sum(sum(double(Dbothfin(:,:,4))==0))];
				area_dna = [area_dna; sum(sum(double(segdna(:,:,4))==1))];  %%
				stats = regionprops(bwlabel(~Dbothfin(:,:,4)),'Area','MajorAxisLength','MinorAxisLength');
				Area_all = [];
				for ii = 1:length(stats)
					Area_all = [Area_all; stats(ii).Area];
				end
				[~,tmpind] = max(Area_all);
				major_Dbothfin = [major_Dbothfin; stats(tmpind).MajorAxisLength];  %%
				segcell = double(~(Dbothfin)) + double(segdna);
				area_segcell = [area_segcell; sum(sum(double(segcell(:,:,1)==1)))];
				stats = regionprops(bwlabel(segcell(:,:,4)),'Area','MajorAxisLength','MinorAxisLength');
				Area_all = [];
				for ii = 1:length(stats)
					Area_all = [Area_all; stats(ii).Area];
				end
				[~,tmpind] = max(Area_all);
				major_segcell = [major_segcell; stats(tmpind).MajorAxisLength];  %%
				vol_Dbothfin = [vol_Dbothfin; sum(sum(sum(double(Dbothfin)==0)))];
				realMT = [realMT; sum(sum(double(protim3)))];
				keys_all2 = [keys_all2; [setno fieldno imnum]];

				start_point = imgcent_coordinate(:);
				M = double(~Dbothfin);
				W = abs( M - M(start_point(1),start_point(2),start_point(3)) );
				W = rescale(W,1e-3,1);
				options.nb_iter_max = Inf;
				[D,S] = perform_fast_marching(1./W, start_point, options);
				tmpD = D; D = 1./D; 
				D(start_point(1),start_point(2),start_point(3)) = 0;
				D(start_point(1),start_point(2),start_point(3)) = max(max(max(D))); 
				D = D.*M; D = D/max(max(max(D)));
				areaD = [areaD; sum(sum(double(D(:,:,4))))];
				volD = [volD; sum(sum(sum(double(D))))];
			end
		end
	end
end
cd(currentdir)

load HPAimagelist2.mat AddCellLines celllabels 
cellnums = [1:50];
for setno = unique(celllabels)'
       fieldnos = 1:sum(celllabels==setno);
	for fieldno = fieldnos
		for imnum = cellnums
			disp([setno, fieldno, imnum]);
			myfile = ['proc_6/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/Image_' num2str(imnum) '/final_info.mat'];
			if (exist(myfile,'file') == 2)
				[protim3,Dbothfin,segdna,imgcent_coordinate] = getrealimage_hpa(setno,fieldno,imnum);
				area_Dbothfin = [area_Dbothfin; sum(sum(double(Dbothfin(:,:,4))==0))];
				area_dna = [area_dna; sum(sum(double(segdna(:,:,4))==1))];  %%
				stats = regionprops(bwlabel(~Dbothfin(:,:,4)),'Area','MajorAxisLength','MinorAxisLength');
				Area_all = [];
				for ii = 1:length(stats)
					Area_all = [Area_all; stats(ii).Area];
				end
				[~,tmpind] = max(Area_all);
				major_Dbothfin = [major_Dbothfin; stats(tmpind).MajorAxisLength];  %%
				segcell = double(~(Dbothfin)) + double(segdna);
				area_segcell = [area_segcell; sum(sum(double(segcell(:,:,1)==1)))];
				stats = regionprops(bwlabel(segcell(:,:,4)),'Area','MajorAxisLength','MinorAxisLength');
				Area_all = [];
				for ii = 1:length(stats)
					Area_all = [Area_all; stats(ii).Area];
				end
				[~,tmpind] = max(Area_all);
				major_segcell = [major_segcell; stats(tmpind).MajorAxisLength];  %%
				vol_Dbothfin = [vol_Dbothfin; sum(sum(sum(double(Dbothfin)==0)))];
				realMT = [realMT; sum(sum(double(protim3)))];
				keys_all2 = [keys_all2; [setno fieldno imnum]];

				start_point = imgcent_coordinate(:);
				M = double(~Dbothfin);
				W = abs( M - M(start_point(1),start_point(2),start_point(3)) );
				W = rescale(W,1e-3,1);
				options.nb_iter_max = Inf;
				[D,S] = perform_fast_marching(1./W, start_point, options);
				tmpD = D; D = 1./D; 
				D(start_point(1),start_point(2),start_point(3)) = 0;
				D(start_point(1),start_point(2),start_point(3)) = max(max(max(D))); 
				D = D.*M; D = D/max(max(max(D)));
				areaD = [areaD; sum(sum(double(D(:,:,4))))];
				volD = [volD; sum(sum(sum(double(D))))];
			end
		end
	end
end

sum(sum(keys_all-keys_all2))
idx = find(area_Dbothfin>0);


finTable_all1 = finTable_all(:,1); finTable_all2 = finTable_all(:,2);
totalMT = prod(finTable_all(:,[1,2]),2);
keepidx_totalMT = []; 
keepidx_realMT = []; 
keepidx_areaDb = []; idx1 = find(area_Dbothfin>0);
keepidx_areaD = []; idx2 = find(areaD>0);
keepidx_fin1 = [];
keepidx_fin2 = [];
pp1 = 0; pp2 = 0; pp3 = 0; pp4 = 0; pp5 = 0; pp6 = 0;
rr = 1.5;
for i = unique(keys_all(:,1))'
    x = totalMT(keys_all(:,1)==i);
    xmean = median(x);
    %xstd = std(x);
    %idx = pp1 + find((x>xmean-rr*xstd) & (x<xmean+rr*xstd));
    xstd = quantile(x,[0.25,0.75]);
    idx = pp1 + find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    pp1 = pp1 + length(find(keys_all(:,1)==i));
    keepidx_totalMT = [keepidx_totalMT;idx];

    x = realMT(keys_all(:,1)==i);
    xmean = median(x);
    %xstd = std(x);
    %idx = pp2 + find((x>xmean-rr*xstd) & (x<xmean+rr*xstd));
    xstd = quantile(x,[0.25,0.75]);
    idx = pp2 + find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    pp2 = pp2 + length(find(keys_all(:,1)==i));
    keepidx_realMT = [keepidx_realMT;idx];

    x = area_Dbothfin(keys_all(:,1)==i);
    xmean = median(x);
    %xstd = std(x);
    %idx = pp3 + find((x>xmean-rr*xstd) & (x<xmean+rr*xstd));
    xstd = quantile(x,[0.25,0.75]);
    idx = pp3 + find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    pp3 = pp3 + length(find(keys_all(:,1)==i));
    keepidx_areaDb = [keepidx_areaDb;idx];

    x = areaD(keys_all(:,1)==i);
    xmean = median(x);
    %xstd = std(x);
    %idx = pp4 + find((x>xmean-rr*xstd) & (x<xmean+rr*xstd));
    xstd = quantile(x,[0.25,0.75]);
    idx = pp4 + find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    pp4 = pp4 + length(find(keys_all(:,1)==i));
    keepidx_areaD = [keepidx_areaD;idx];

    x = finTable_all1(keys_all(:,1)==i);
    xmean = median(x);
    %xstd = std(x);
    %idx = pp5 + find((x>xmean-rr*xstd) & (x<xmean+rr*xstd));
    xstd = quantile(x,[0.25,0.75]);
    idx = pp5 + find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    pp5 = pp5 + length(find(keys_all(:,1)==i));
    keepidx_fin1 = [keepidx_fin1;idx];

    x = finTable_all2(keys_all(:,1)==i);
    xmean = median(x);
    %xstd = std(x);
    %idx = pp6 + find((x>xmean-rr*xstd) & (x<xmean+rr*xstd));
    xstd = quantile(x,[0.25,0.75]);
    idx = pp6 + find((x>xstd(1)-rr*(xstd(2)-xstd(1))) & (x<xstd(1)+rr*(xstd(2)-xstd(1))));
    pp6 = pp6 + length(find(keys_all(:,1)==i));
    keepidx_fin2 = [keepidx_fin2;idx];
end
keepidx_areaDb = union(keepidx_areaDb, idx1);
keepidx_areaD = union(keepidx_areaD, idx2);
finTable_all1 = finTable_all1(keepidx_fin1);
finTable_all2 = finTable_all2(keepidx_fin2);




keys = keys_all;

%save wrap_all_Celllines_cluster.mat
save wrap_all_Celllines_cluster_s3.mat

%save wrap_all_Celllines_cluster2.mat -v4
save wrap_all_Celllines_cluster_s3.mat -v4

