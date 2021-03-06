function [G_psf,G] = getsynimage_hpa(n,mu_len,sigma_len,colli_min_number,imnum,batchno,setno,fieldno,subfolder,rad,thr)

myfile =  ['outputs_' num2str(subfolder) '/images/set_' num2str(setno) '/fieldno_' num2str(fieldno) '/thr_' num2str(thr) '/Image_' num2str(imnum) '/batch_' num2str(batchno) '/new_n_' num2str(n) '/new_sim_n_' num2str(n) '_mulen_' num2str(mu_len) '_siglen_' num2str(sigma_len) '_colli_' num2str(colli_min_number) '.mat'];

load(myfile,'G');
G_psf = psf_blur_HPA(G,rad);
G_psf = scalmultcode_hpa(setno,rad)*G_psf;

end % End of function
