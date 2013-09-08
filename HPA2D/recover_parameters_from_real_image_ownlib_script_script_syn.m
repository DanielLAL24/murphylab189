clear all
close all

%w = [1;1;1;1;1;1;1];
w = [1,1,1,1,1,1,1,0,0,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,1,1,1
     0,0,0,0,1,1,1,1,1,1,1,1,1
     1,1,1,1,1,1,1,1,1,1,1,1,1];

batchnos = 2:6;

for batchno = batchnos
for i = 1:size(w,1)
%for setno = 1:3
for setno = 3
	%recover_parameters_from_real_image_ownlib_script(setno,w(i,:));
       fieldno = 7; imnum = 1;
	recover_parameters_from_real_image_ownlib_script(setno,w(i,:),fieldno,imnum,batchno);
end
end
end
