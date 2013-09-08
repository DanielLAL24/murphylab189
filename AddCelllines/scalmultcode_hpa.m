function scalmult = scalmultcode_hpa(setno,rad)

cc = zeros(25,25,13);
cc(:,13,7) = 1;
cc2 = psf_blur_HPA(cc,rad);
psfpeak = max(cc2(:));

load mtints mint
mt = [];
for fieldno = 1:size(mint,2)  %% 
	mt = [mt,mint{setno,fieldno}];
end

scalmult = mean(mt)/psfpeak;

end %  End of function
