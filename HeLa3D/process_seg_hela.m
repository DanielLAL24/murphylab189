function process_seg_hela( cellnum )
 
load([ pwd filesep 'proc/cell_' num2str(cellnum) '/man_seg.mat'],'segcell','segdna','protim3');

output_filename = [ pwd filesep 'proc/cell_' num2str(cellnum) '/final_info.mat'];

if ~exist( output_filename )
	cell_image = segcell;
	dna_image = segdna;

	% add stack of zeros at the top and bottom of the image
	cell_image = as_addStack(cell_image,20,0);
	dna_image = as_addStack(dna_image,20,0);

	% reverse the numbering of binary image of cell_image
	temp_image = cell_image;
	cell_image(find(temp_image==0)) = 1;
	cell_image(find(temp_image==1)) = 0;

	Dbothfin = cell_image + dna_image;
	Dbothfin(find(Dbothfin>1)) = 1;

	XYZres = 0.2;

	% Uncomment the following code to detect centrosome

	% imgcent_coordinate = search_cent_3(protim3);
	% imgcent_coordinate(3) = imgcent_coordinate(3) + 20;
	% imgcent_coordinate = imgcent_coordinate';

	% the following are the corrections after detecting centrosome using above commented code
	load centrosome
	imgcent_coordinate = imcents(:,cellnum);

	save( output_filename );
else
	disp( 'Intermediate results found. Skipping recalculation.')
end
