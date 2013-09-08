function raw2proc_hela( cellnum, imgloc )

%{
protim3 = ml_loadimage(['raw/cell' num2str(cellnum) '/prot/'],'tif');
dnaim3 = ml_loadimage(['raw/cell' num2str(cellnum) '/dna/'],'tif');
cellim3 = ml_loadimage(['raw/cell' num2str(cellnum) '/cell/'],'tif');
mask = ml_loadimage(['raw/cell' num2str(cellnum) '/crop/'],'tif');
%}

output_folder = ['proc/cell_' num2str(cellnum)];
output_filename = [ 'proc/cell_' num2str(cellnum) '/cell' num2str(cellnum) '.mat'];

if ~exist( output_filename )
	if ~exist( 'imgloc','var' ) || isempty( imgloc )
	   warning(['Variable imgloc points to a nonexisting folder:''' imgloc '''. Defaulting to ''/share/images/Hela'''])
	   imgloc = '/share/images/Hela';
	else
		%disp(['Folder imgloc:''' imgloc ''' found.'])	
	end

	%icaoberg 9/8/2013
	%updated location to match the downloaded tarball from masterscript
	disp( 'Loading images')
	protim3 = ml_loadimage([imgloc '/Tub/cell' num2str(cellnum) '/prot/'],'tif');
	dnaim3 = ml_loadimage([imgloc '/Tub/cell' num2str(cellnum) '/dna/'],'tif');
	cellim3 = ml_loadimage([imgloc '/Tub/cell' num2str(cellnum) '/cell/'],'tif');
	mask = ml_loadimage([imgloc '/Tub/cell' num2str(cellnum) '/crop/'],'tif');

	disp( 'Applying mask to images' )
	protim3 = tz_maskimg_3d(protim3,mask);
	dnaim3 = tz_maskimg_3d(dnaim3,mask);
	cellim3 = tz_maskimg_3d(cellim3,mask);

	disp( 'Downsizing images' )
	protim3 = ml_downsize(protim3,[4 4 1],'average');
	dnaim3 = ml_downsize(dnaim3,[4 4 1],'average');
	cellim3 = ml_downsize(cellim3,[4 4 1],'average');

	disp( 'Saving files' )
	% Resize the image so that resolutions match in X,Y,Z
	if ~exist( output_folder )
		mkdir( output_folder );
	end
	save( output_filename );
else
	disp( 'Intermediate results found. Skipping recalculation.')
end
