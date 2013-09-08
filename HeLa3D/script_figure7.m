clear all
close all

% Figure 7: Query and best matches

dnaseg(1,:) = [6 9];
dnaseg(2,:) = [7 12];
dnaseg(4,:) = [7 12];
dnaseg(6,:) = [6 9];
dnaseg(10,:) = [7 11];
dnaseg(11,:) = [6 9];
dnaseg(12,:) = [5 11];
dnaseg(13,:) = [7 11];
dnaseg(14,:) = [6 8];
dnaseg(15,:) = [6 14];
dnaseg(16,:) = [8 14];
dnaseg(17,:) = [8 12];
dnaseg(18,:) = [7 14];
dnaseg(19,:) = [6 8];
dnaseg(20,:) = [7 11];

dnaseg(21,:) = [7 10];
dnaseg(22,:) = [7 14];
dnaseg(23,:) = [6 13];
dnaseg(24,:) = [6 13];
dnaseg(25,:) = [6 9];

dnaseg(26,:) = [8 14];
dnaseg(27,:) = [7 14];
dnaseg(28,:) = [6 10];
dnaseg(29,:) = [7 14];
dnaseg(30,:) = [6 11];
dnaseg(31,:) = [6 8];
dnaseg(32,:) = [7 10];
dnaseg(33,:) = [7 13];
dnaseg(34,:) = [7 12];
dnaseg(35,:) = [7 14];
dnaseg(36,:) = [8 15];
dnaseg(37,:) = [7 11];
dnaseg(38,:) = [7 11];
dnaseg(39,:) = [7 10];
dnaseg(40,:) = [5 10];
dnaseg(41,:) = [6 10];
dnaseg(42,:) = [7 12];
dnaseg(46,:) = [7 11];
dnaseg(47,:) = [7 10];
dnaseg(48,:) = [7 14];
dnaseg(49,:) = [8 13];
dnaseg(51,:) = [7 10];
dnaseg(52,:) = [7 10];
J = 1;
%for cellnum = [18 19 20]
for cellnum = [1 2 4 6 10 12:42 46:49 51:52]
	% Real Image
	protim3 = getrealimage_hela(cellnum);
	I = getmaxintslcno(protim3);
	
	% Synthetic best fit image
	load(['./outputs_3/results/result_new_1_1_1_1_1_1_1_0_0_0_0_0_0.mat'],'finTable');
       idx = find(finTable(:,6)==cellnum);
	[G_psf,imgcent_coordinate,imXYZ,G,mtXYZ] = getsynimage_hela(finTable(idx,1),finTable(idx,2),finTable(idx,3),finTable(idx,4),cellnum,1,3);
	ff(J,:) = finTable(idx,1:4);
	J = J + 1;

       save(['./cellfits/cell',num2str(cellnum),'.mat']);
       %{
	% Plot
       load(['./cellfits/cell',num2str(cellnum),'.mat']);
	fh = figure
	%set(fh,'color','white');
	scal = 255/max(max(protim3(:,:,dnaseg(cellnum,1))));
	% Add scale bar
	% if cellnum == 18
       %         protim3(240:245,178:228,:) = 255;
       % end
	imshow(uint8(scal*protim3(:,:,dnaseg(cellnum,1))),[]);
       saveas(fh,['./cellfits/cell',num2str(cellnum),'-real.tif']);

	fh2 = figure
	%set(fh2,'color','white');
	I = getmaxintslcno(G_psf);
	imshow(uint8(scal*G_psf(:,:,dnaseg(cellnum,1))),[]);
       saveas(fh2,['./cellfits/cell',num2str(cellnum),'-sim.tif']);
       %}
end
