clear all
close all

%w = [1;1;1;1;1;1;1];
w = [1,1,1,1,1,1,1,0,0,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,0,0,0
     0,0,0,0,1,1,1,1,1,0,1,1,1
     0,0,0,0,1,1,1,1,1,1,1,1,1
     1,1,1,1,1,1,1,1,1,1,1,1,1];

for i = 1:size(w,1)
for setno = 3
	recover_parameters_from_real_image_ownlib_script(setno,w(i,:));
end
end
