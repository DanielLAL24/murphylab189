
bg_int = sum(bg_prot(:));
bg_int_mthr = sum(bg_prot_mthr(:));

feats = zeros(1,4);
feats(1) = bg_int / (prot_int + bg_int);
feats(2) = bg_int / (prot_int_large + bg_int);
feats(3) = bg_int_mthr / (prot_int_mthr + bg_int_mthr);
feats(4) = bg_int_mthr / (prot_int_large_mthr + bg_int_mthr);

names = {'non_object_fluorescence','non_large_object_fluorescence',...
         'non_object_fluorescence_mthr','non_large_object_fluorescence_mthr'};
         
slfnames = {'7.79',''};
