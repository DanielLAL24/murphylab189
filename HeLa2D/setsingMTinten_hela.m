function G_psf = setsingMTinten_hela(G,cellnum)

% load intensities mcXs
% I = 1; for cellnum = [1 2 4 6 10 12:42 46:49 51 52], mcX = mcXs(cellnum,:); tt(I)= mcX(4); I = I + 1; end
% mtt = ceil(mean(tt));

mtt = 19;

% cc = zeros(9,9,9);  
% cc(:,5,5) = 1;
% cc2 = psf_blur_hela_mean(cc);
% psfpeak = max(cc2(:));

psfpeak = 0.08;

G_psf = G*(mtt/psfpeak);

end
