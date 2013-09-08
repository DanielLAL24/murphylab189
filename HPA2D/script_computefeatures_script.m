function script_computefeatures_script(setno)

subfolder = 1;
feat_vec_all = [];
keys_all = [];
fieldno = 1;

while size(feat_vec_all,1) < 1001
	[feat_vec,keys] = script_computefeatures(setno,fieldno);
	feat_vec_all = [feat_vec_all;feat_vec];
	keys_all = [keys_all;keys];
	fieldno = fieldno + 1;
end

mkdir(['outputs_' num2str(subfolder) '/cluster/set_' num2str(setno)]);
save(['outputs_' num2str(subfolder) '/cluster/set_' num2str(setno) '/result.mat']);

end  % end of function
