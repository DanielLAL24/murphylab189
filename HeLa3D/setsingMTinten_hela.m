function G_psf = setsingMTinten_hela(G,cellnum)

mtt = 19;
psfpeak = 0.08;

G_psf = G*(mtt/psfpeak);

end
