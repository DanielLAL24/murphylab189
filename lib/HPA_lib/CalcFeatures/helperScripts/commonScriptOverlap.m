

[feats1,names1] = features_overlap( tmp_prot, tmp_prot_fg, tmp_nuc_fg, 'nuc');
[feats2,names2] = features_overlap( tmp_prot, tmp_prot_fg, tmp_tub_fg, 'tub');
[feats3,names3] = features_overlap( tmp_prot, tmp_prot_fg, tmp_er_fg, 'er');

[feats4,names4] = features_overlap( tmp_prot, tmp_prot_large_fg, tmp_nuc_fg, 'nuc_large');
[feats5,names5] = features_overlap( tmp_prot, tmp_prot_large_fg, tmp_tub_fg, 'tub_large');
[feats6,names6] = features_overlap( tmp_prot, tmp_prot_large_fg, tmp_er_fg, 'er_large');

[feats7,names7] = features_overlap( tmp_prot, tmp_prot_mfg, tmp_nuc_fg, 'nuc_mthr');
[feats8,names8] = features_overlap( tmp_prot, tmp_prot_mfg, tmp_tub_fg, 'tub_mthr');
[feats9,names9] = features_overlap( tmp_prot, tmp_prot_mfg, tmp_er_fg, 'er_mthr');

[feats10,names10] = features_overlap( tmp_prot, tmp_prot_large_mfg, tmp_nuc_fg, 'nuc_mthr_large');
[feats11,names11] = features_overlap( tmp_prot, tmp_prot_large_mfg, tmp_tub_fg, 'tub_mthr_large');
[feats12,names12] = features_overlap( tmp_prot, tmp_prot_large_mfg, tmp_er_fg, 'er_mthr_large');

feats = [feats1 feats2 feats3 feats4 feats5 feats6 feats7 feats8 feats9 feats10 feats11 feats12];
names = [names1 names2 names3 names4 names5 names6 names7 names8 names9 names10 names11 names12];

tmp_idx = 3:4:length(feats);

feats(tmp_idx(4:end)) = [];
names(tmp_idx(4:end)) = [];

slfnames = repmat({''},[1 length(names)]);
