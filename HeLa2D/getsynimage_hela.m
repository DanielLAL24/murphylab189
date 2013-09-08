function [G_psf,imgcent_coordinate] = getsynimage_hela(n,mu_len,sigma_len,colli_min_number,cellnum,batchno,subfolder,thr)

myfile = ['outputs_' num2str(subfolder) '/images/thr_' num2str(thr) '/cell_' num2str(cellnum) '/batch_' num2str(batchno) '/new_n_' num2str(n) '/new_sim_n_' num2str(n) '_mulen_' num2str(mu_len) '_siglen_' num2str(sigma_len) '_colli_' num2str(colli_min_number) '.mat'];


load(myfile,'imgcent_coordinate','G');
G_psf = psf_blur_hela_mean(G);
G_psf = setsingMTinten_hela(G_psf,cellnum);

imgcent_coordinate(3) = imgcent_coordinate(3);
