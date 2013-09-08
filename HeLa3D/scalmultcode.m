function scalmult = scalmultcode()

cc = zeros(11,11,11);
cc(:,6,6) = 1;
cc2 = psf_blur_hela_mean(cc);
psfpeak = max(cc2(:));

scalmult = avgmtint/psfpeak;
