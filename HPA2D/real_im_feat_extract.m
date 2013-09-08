function feat_vector_ori = real_im_feat_extract(image,imgcent_coordinate,w,setno,fieldno,cellnum)


imCategory = 'general';
%w = [1;1;1;1;1;1;1];

feat_vector_ori = getfeatvector_hpa(image,imgcent_coordinate,imCategory,w,setno,fieldno,cellnum);

% End of function
